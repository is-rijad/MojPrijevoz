using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareIdFromFareOfferRemove : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer");

            migrationBuilder.DropIndex(
                name: "IX_FareOffer_FareId",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "FareId",
                table: "FareOffer");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "FareId",
                table: "FareOffer",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_FareOffer_FareId",
                table: "FareOffer",
                column: "FareId");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer",
                column: "FareId",
                principalTable: "Fare",
                principalColumn: "Id");
        }
    }
}
