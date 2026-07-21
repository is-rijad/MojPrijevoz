using MojPrijevoz.Database;

namespace MojPrijevoz.Services.Helpers;

public static class StatusHelper
{
    public static Dictionary<AccountStatus, string> AccountStatusDictionary = new()
    {
        [AccountStatus.Active] = "Aktivan",
        [AccountStatus.Banned] = "Banovan",
        [AccountStatus.WaitingForChanges] = "Čeka na promjene",
        [AccountStatus.WaitingForReview] = "Čeka na pregled"
    };
    public static Dictionary<FareStatus, string> FareStatusDictionary = new()
    {
        [FareStatus.Rejected] = "Odbijena",
        [FareStatus.Accepted] = "Prihvaćena",
        [FareStatus.InNegotiation] = "U pregovorima",
        [FareStatus.Expired] = "Istekla",
        [FareStatus.Payed] = "Plaćena",
        [FareStatus.Cancelled] = "Otkazana",
        [FareStatus.InProgress] = "U toku",
        [FareStatus.Completed] = "Završena",
    };
}