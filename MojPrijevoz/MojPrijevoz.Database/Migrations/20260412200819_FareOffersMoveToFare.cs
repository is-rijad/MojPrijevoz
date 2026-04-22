using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareOffersMoveToFare : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_FareData_FareDataId",
                table: "FareOffer");

            migrationBuilder.RenameColumn(
                name: "FareDataId",
                table: "FareOffer",
                newName: "FareId");

            migrationBuilder.RenameIndex(
                name: "IX_FareOffer_FareDataId",
                table: "FareOffer",
                newName: "IX_FareOffer_FareId");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer",
                column: "FareId",
                principalTable: "Fare",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer");

            migrationBuilder.RenameColumn(
                name: "FareId",
                table: "FareOffer",
                newName: "FareDataId");

            migrationBuilder.RenameIndex(
                name: "IX_FareOffer_FareId",
                table: "FareOffer",
                newName: "IX_FareOffer_FareDataId");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_FareData_FareDataId",
                table: "FareOffer",
                column: "FareDataId",
                principalTable: "FareData",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
