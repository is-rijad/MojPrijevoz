using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;

namespace MojPrijevoz.Database;

public class City {
    public int Id { get; set; }

    public string Name { get; set; } = null!;

    public string Long { get; set; } = null!;

    public string Lat { get; set; } = null!;


    public ICollection<User>? Users { get; set; }

    public DateTime UpdatedAt { get; set; }

    public DateTime CreatedAt { get; set; }
}

public class CityEntityConfiguration : IEntityTypeConfiguration<City> {
    public void Configure(EntityTypeBuilder<City> entity) {
        entity.HasKey(e => e.Id);

        entity.ToTable("City");

        entity.Property(e => e.Lat)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.Long)
            .HasMaxLength(16)
            .IsUnicode(false);
        entity.Property(e => e.Name)
            .HasMaxLength(32)
            .IsUnicode();
        entity.Property(e => e.CreatedAt).ValueGeneratedOnAdd()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");
        entity.Property(e => e.UpdatedAt).ValueGeneratedOnAddOrUpdate()
            .HasDefaultValueSql("CURRENT_TIMESTAMP");

        entity.HasData(
            new City { Id = 1, Name = "Banja Luka", Lat = "44.7725", Long = "17.1925" },
            new City { Id = 2, Name = "Banovići", Lat = "44.4000", Long = "18.5333" },
            new City { Id = 3, Name = "Bihać", Lat = "44.8167", Long = "15.8667" },
            new City { Id = 4, Name = "Bijeljina", Lat = "44.7569", Long = "19.2161" },
            new City { Id = 5, Name = "Bileća", Lat = "42.8667", Long = "18.4333" },
            new City { Id = 6, Name = "Bosanska Krupa", Lat = "44.8833", Long = "16.1500" },
            new City { Id = 7, Name = "Bratunac", Lat = "44.1839", Long = "19.3308" },
            new City { Id = 8, Name = "Breza", Lat = "44.0167", Long = "18.2611" },
            new City { Id = 9, Name = "Brčko", Lat = "44.8772", Long = "18.8111" },
            new City { Id = 10, Name = "Brod", Lat = "45.1333", Long = "17.9833" },
            new City { Id = 11, Name = "Bugojno", Lat = "44.0500", Long = "17.4500" },
            new City { Id = 12, Name = "Busovača", Lat = "44.1000", Long = "17.8833" },
            new City { Id = 13, Name = "Cazin", Lat = "44.9667", Long = "15.9333" },
            new City { Id = 14, Name = "Čapljina", Lat = "43.1118", Long = "17.7055" },
            new City { Id = 15, Name = "Čelić", Lat = "44.7167", Long = "18.8167" },
            new City { Id = 16, Name = "Čitluk", Lat = "43.2000", Long = "17.7000" },
            new City { Id = 17, Name = "Derventa", Lat = "44.9775", Long = "17.9075" },
            new City { Id = 18, Name = "Doboj", Lat = "44.7314", Long = "18.0844" },
            new City { Id = 19, Name = "Donji Kakanj", Lat = "44.1311", Long = "18.0972" },
            new City { Id = 20, Name = "Donji Vakuf", Lat = "44.1500", Long = "17.4000" },
            new City { Id = 21, Name = "Foča", Lat = "43.5064", Long = "18.7747" },
            new City { Id = 22, Name = "Fojnica", Lat = "43.9667", Long = "17.9000" },
            new City { Id = 23, Name = "Gacko", Lat = "43.1667", Long = "18.5333" },
            new City { Id = 24, Name = "Goražde", Lat = "43.6667", Long = "18.9833" },
            new City { Id = 25, Name = "Gornji Vakuf", Lat = "43.9333", Long = "17.5833" },
            new City { Id = 26, Name = "Gradačac", Lat = "44.8789", Long = "18.4258" },
            new City { Id = 27, Name = "Gradiška", Lat = "45.1458", Long = "17.2539" },
            new City { Id = 28, Name = "Gračanica", Lat = "44.6892", Long = "18.3022" },
            new City { Id = 29, Name = "Hadžići", Lat = "43.8217", Long = "18.2017" },
            new City { Id = 30, Name = "Ilidža", Lat = "43.8167", Long = "18.3000" },
            new City { Id = 31, Name = "Ilijaš", Lat = "43.9500", Long = "18.2667" },
            new City { Id = 32, Name = "Jablanica", Lat = "43.6500", Long = "17.7500" },
            new City { Id = 33, Name = "Jajce", Lat = "44.3417", Long = "17.2694" },
            new City { Id = 34, Name = "Kiseljak", Lat = "43.9431", Long = "18.0775" },
            new City { Id = 35, Name = "Kladanj", Lat = "44.2256", Long = "18.6925" },
            new City { Id = 36, Name = "Ključ", Lat = "44.5333", Long = "16.7667" },
            new City { Id = 37, Name = "Livno", Lat = "43.8253", Long = "17.0058" },
            new City { Id = 38, Name = "Lopare", Lat = "44.6361", Long = "18.8444" },
            new City { Id = 39, Name = "Lukavac", Lat = "44.5500", Long = "18.5167" },
            new City { Id = 40, Name = "Ljubuški", Lat = "43.1981", Long = "17.5467" },
            new City { Id = 41, Name = "Maglaj", Lat = "44.5500", Long = "18.1000" },
            new City { Id = 42, Name = "Milići", Lat = "44.1661", Long = "19.0750" },
            new City { Id = 43, Name = "Mostar", Lat = "43.3436", Long = "17.8075" },
            new City { Id = 44, Name = "Novi Grad", Lat = "45.0481", Long = "16.3769" },
            new City { Id = 45, Name = "Novi Travnik", Lat = "44.1748", Long = "17.6634" },
            new City { Id = 46, Name = "Odžak", Lat = "45.0106", Long = "18.3264" },
            new City { Id = 47, Name = "Olovo", Lat = "44.1275", Long = "18.5800" },
            new City { Id = 48, Name = "Orašje", Lat = "45.0361", Long = "18.6933" },
            new City { Id = 49, Name = "Pale", Lat = "43.8119", Long = "18.5711" },
            new City { Id = 50, Name = "Posušje", Lat = "43.4720", Long = "17.3297" },
            new City { Id = 51, Name = "Prijedor", Lat = "44.9808", Long = "16.7133" },
            new City { Id = 52, Name = "Rogatica", Lat = "43.7986", Long = "19.0036" },
            new City { Id = 53, Name = "Sanski Most", Lat = "44.7667", Long = "16.6667" },
            new City { Id = 54, Name = "Sapna", Lat = "44.4917", Long = "19.0028" },
            new City { Id = 55, Name = "Sarajevo", Lat = "43.8564", Long = "18.4131" },
            new City { Id = 56, Name = "Srebrenica", Lat = "44.1042", Long = "19.2972" },
            new City { Id = 57, Name = "Srebrenik", Lat = "44.7000", Long = "18.4833" },
            new City { Id = 58, Name = "Stara Gora", Lat = "43.8667", Long = "18.4333" },
            new City { Id = 59, Name = "Stolac", Lat = "43.0825", Long = "17.9558" },
            new City { Id = 60, Name = "Široki Brijeg", Lat = "43.3831", Long = "17.5927" },
            new City { Id = 61, Name = "Tešanj", Lat = "44.6142", Long = "17.9894" },
            new City { Id = 62, Name = "Travnik", Lat = "44.2264", Long = "17.6597" },
            new City { Id = 63, Name = "Trebinje", Lat = "42.7119", Long = "18.3461" },
            new City { Id = 64, Name = "Tuzla", Lat = "44.5381", Long = "18.6761" },
            new City { Id = 65, Name = "Vareš", Lat = "44.1619", Long = "18.3269" },
            new City { Id = 66, Name = "Visoko", Lat = "43.9833", Long = "18.1667" },
            new City { Id = 67, Name = "Vitez", Lat = "44.1585", Long = "17.7885" },
            new City { Id = 68, Name = "Vlasenica", Lat = "44.1833", Long = "18.9333" },
            new City { Id = 69, Name = "Vogošća", Lat = "43.9000", Long = "18.3500" },
            new City { Id = 70, Name = "Zvornik", Lat = "44.3842", Long = "19.1025" },
            new City { Id = 71, Name = "Žepče", Lat = "44.4333", Long = "18.0333" },
            new City { Id = 72, Name = "Živinice", Lat = "44.4500", Long = "18.6500" }
        );

    }
}