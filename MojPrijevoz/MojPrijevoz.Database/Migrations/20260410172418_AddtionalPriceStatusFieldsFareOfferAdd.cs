using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations {
    /// <inheritdoc />
    public partial class AddtionalPriceStatusFieldsFareOfferAdd : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<float>(
                name: "AdditionalPrice",
                table: "FareOffer",
                type: "real",
                nullable: true);

            migrationBuilder.AddColumn<short>(
                name: "Status",
                table: "FareOffer",
                type: "smallint",
                nullable: false,
                defaultValue: (short)0);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "AdditionalPrice",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "Status",
                table: "FareOffer");
        }
    }
}
