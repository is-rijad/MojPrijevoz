using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations {
    /// <inheritdoc />
    public partial class UserVehicleMoveToFare : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId",
                table: "FareOffer");

            migrationBuilder.DropIndex(
                name: "IX_FareOffer_UserVehicleId",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "UserVehicleId",
                table: "FareOffer");

            migrationBuilder.AddColumn<int>(
                name: "UserVehicleId",
                table: "Fare",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_Fare_UserVehicleId",
                table: "Fare",
                column: "UserVehicleId");

            migrationBuilder.AddForeignKey(
                name: "FK_Fare_UserVehicle_UserVehicleId",
                table: "Fare",
                column: "UserVehicleId",
                principalTable: "UserVehicle",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_Fare_UserVehicle_UserVehicleId",
                table: "Fare");

            migrationBuilder.DropIndex(
                name: "IX_Fare_UserVehicleId",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "UserVehicleId",
                table: "Fare");

            migrationBuilder.AddColumn<int>(
                name: "UserVehicleId",
                table: "FareOffer",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateIndex(
                name: "IX_FareOffer_UserVehicleId",
                table: "FareOffer",
                column: "UserVehicleId");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId",
                table: "FareOffer",
                column: "UserVehicleId",
                principalTable: "UserVehicle",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
