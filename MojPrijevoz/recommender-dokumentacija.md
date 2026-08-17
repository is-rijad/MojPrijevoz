# MojPrijevoz Recommender sistem

Tehnička dokumentacija recommender sistema za preporuku vozača na osnovu historije vožnji.

## 1. Svrha

Recommender predlaže putniku vozače na rutama koje **nije sam pretraživao**, ali za koje model
procjenjuje da bi ga mogle zanimati na osnovu obrasca njegovih dosadašnjih završenih vožnji i
obrazaca sličnih putnika (**collaborative-filtering**).

Sistem je izdvojen u zaseban projekat `MojPrijevoz.Recommender` unutar istog solutiona. Radi kao in-process servis, tj. nije zasebna mikroservisna instanca.

## 2. Algoritam

**Matrix Factorization** (`Microsoft.ML.Recommender`, `MatrixFactorizationTrainer`) sa
implicitnim feedbackom (`SquareLossOneClass`).

- **Redovi matrice:** rute, identifikovane parom `(OriginCityId, DestinationZone)`
- **Kolone matrice:** putnici
- **Ćelija (putnik, ruta):** ako putnik ima barem jednu **završenu** (`FareStatus.Completed`)
  vožnju na toj ruti, sve ostale ćelije se u treningu tretiraju implicitno kao negativne, sa
  težinom `C` (0.001) i stopom učenja `Alpha` (0.01)
- **Rang aproksimacije:** 32 latentna faktora, 20 iteracija treninga

Ovo je **implicit feedback** postavka, model ne uči koliko puta je putnik prisustvovao ruti, nego
da li bi ta ruta mogla interesovati putnika.

> **Zašto ne broj vožnji kao label:** `SquareLossOneClass` pretpostavlja binarnu prisutnost
> interakcije. Label koji raste (1, 2, 15...) unosi nekonzistentnu skalu u loss funkciju koja
> očekuje jedinstvenu pozitivnu vrijednost.

## 3. Domenski podaci i indeksiranje

### 3.1 Zašto postoji indeksiranje

ML.NET `MatrixFactorization` zahtijeva da redovi/kolone matrice budu **uzastopne cjelobrojne
vrijednosti** (`KeyType`), počevši od 0. Sirovi `PassengerId` iz baze i kombinacija
`(OriginCityId, DestinationZone)` to nisu, pa se mapiraju kroz pomoćnu klasu `RouteIndex`.

### 3.2 `RouteIndex`
Ista klasa se koristi za **dvije nezavisne mape**:

| Instanca | Ključ (string) | Vrijednost | Namjena |
|---|---|---|---|
| `_routeIndex` | `"{OriginCityId}→{DestinationZone}"` | `uint` indeks rute | `MatrixRowIndexColumnName` |
| `_passengerIndex` | `PassengerId.ToString()` | `uint` indeks putnika | `MatrixColumnIndexColumnName` |

### 3.3 `PassengerRouteInteraction` (ulaz u trening/predikciju)

`KeyType.count` je **statički atribut** i on mora biti postavljen na realnu gornju granicu prije
kompajliranja. Ako broj distinct putnika/ruta premaši ove vrijednosti, trening će baciti grešku
ili tiho odbaciti podatke izvan opsega.

### 3.4 `RoutePrediction` (izlaz predikcije)

Viši `Score` znači veća vjerovatnoća da će putnika zanimati ta ruta.

## 4. Concurrency model - atomski swap

`TrainAsync()` traje sekunde do minute (SQL upit + fit MF modela). U tom vremenu servis mora
nastaviti opsluživati `GET /api/recommender` requestove **konzistentnim** stanjem (korisnik ne smije vidjeti npr. novi `_routeIndex` sa
starim `_model`-om koji ne zna za te indekse, ili obrnuto).

Ovaj problem je riješen lokalnim buildom `_routeIndex` i `_model`, praćeno atomičnim swapom istih.

Dodatno, `RecommendDriversAsync()` na početku **snapshotuje** sve četiri reference u lokalne
varijable prije nego što ih koristi.

Time je garantovano da jedan request uvijek radi
sa **jednom konzistentnom generacijom** modela.

## 5. Trening - `TrainAsync()`

**Trigeri:**
- `RecommenderRetrainJob` (BackgroundService) — svaki dan u 02:00 UTC serverskog vremena
- `POST /api/recommender/retrain` — samo u Development okruženju, fire-and-forget u pozadini

Ako u bazi nema nijedne `Completed` vožnje (`completedFares.Count == 0`), trening se prekida bez
promjene postojećeg stanja.

## 6. Predikcija

### 6.1 Cold-start guard (`trainedPassengerIds`)

Putnik ulazi u **personalizovanu** granu samo ako je bio dio posljednjeg treninga
(`_trainedPassengerIds.Contains(passengerId)`). Ovo je namjerno strožije od samog pitanja "ima li uopšte
vožnji u bazi" zato što putnik čija je prva/jedina vožnja završena **poslije** zadnjeg noćnog treninga
još nema naučene faktore u modelu, predikcija za takvog putnika bi bila šum (nule ili
nedefinisano ponašanje), ne signal. Takav putnik pada na `PopularRoutesWithDriversAsync` dok
sljedeći trening (sutra u 02:00, ili ručni retrain u dev-u) ne uključi njegove podatke.

### 6.2 `PopularRoutesWithDriversAsync` - fallback grana

Koristi se kad god personalizacija nije moguća: bez modela, bez poznatih putnikovih ruta, bez
novih ruta za predložiti, ili putnik još nije u modelu. Vraća top 5 najpopularnijih ruta po
broju završenih vožnji svih putnika, pa vozače na njima sortirane po `RidesCount`.

## 7. Gradnja rezultata - `BuildResultAsync()`

Zajednička tačka za obje grane (personalizovanu i popularnu). Prima listu `RouteKeys` i,
opciono, `RouteScores` (`Dictionary<string, float>`).

**Zašto materijalizacija prije paginacije:** MF `Score` dolazi iz `Dictionary` popunjenog van baze
(rezultat `PredictionEngine.Predict`), koji EF Core ne može prevesti u SQL `ORDER BY`. Pošto je
rezultujući skup mali po dizajnu (max 5 ruta), materijalizacija u memoriju prije sortiranja je
prihvatljiv trade-off, ne skalira loše jer gornja granica veličine skupa je fiksna (5 ruta ×
realan broj vozača po ruti).

`Count` u `PagedResult` je ukupan broj **grupa** (driver × ruta), ne broj `Fare` zapisa, odgovara stvarnom broju stavki koje frontend paginira.

## 8. API

### `GET /api/recommender`

**Query:** `RecommendedDriversSearchObject` (`Page`, `PageSize`)
**Auth:** zahtijeva prijavljenog korisnika (`AuthorizationService` čita oba
profila da isključi self-preporuku ako je pozivalac i sam vozač)
**Response:** `PagedResult<RecommendedDriverRouteResponse>`

### `POST /api/recommender/retrain`

**Auth:** `[AllowAnonymous]`, ali interno provjerava `IHostEnvironment.IsDevelopment()`, pa u
Production/Staging vraća `404 NotFound`.
**Ponašanje:** pokreće `TrainAsync()` u pozadini (`Task.Run`, fire-and-forget uz `try/catch` +
`ILogger`), odmah vraća `200 OK` bez čekanja da trening završi.

> Namijenjeno isključivo za lokalni razvoj (npr. nakon seedanja test podataka). U produkciji je
> jedini trigger treninga noćni `RecommenderRetrainJob`.