using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareAndRatingMoveToProfile : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Fare_User_DriverId",
                table: "Fare");

            migrationBuilder.DropForeignKey(
                name: "FK_Fare_User_PassengerId",
                table: "Fare");

            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId",
                table: "FareOffer");

            migrationBuilder.DropForeignKey(
                name: "FK_Rating_User_FromId",
                table: "Rating");

            migrationBuilder.DropForeignKey(
                name: "FK_Rating_User_ToId",
                table: "Rating");

            migrationBuilder.AlterColumn<int>(
                name: "UserVehicleId",
                table: "FareOffer",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AddColumn<int>(
                name: "UserVehicleId1",
                table: "FareOffer",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_FareOffer_UserVehicleId1",
                table: "FareOffer",
                column: "UserVehicleId1");

            migrationBuilder.AddForeignKey(
                name: "FK_Fare_UserProfile_DriverId",
                table: "Fare",
                column: "DriverId",
                principalTable: "UserProfile",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Fare_UserProfile_PassengerId",
                table: "Fare",
                column: "PassengerId",
                principalTable: "UserProfile",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId",
                table: "FareOffer",
                column: "UserVehicleId",
                principalTable: "UserVehicle",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId1",
                table: "FareOffer",
                column: "UserVehicleId1",
                principalTable: "UserVehicle",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rating_UserProfile_FromId",
                table: "Rating",
                column: "FromId",
                principalTable: "UserProfile",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rating_UserProfile_ToId",
                table: "Rating",
                column: "ToId",
                principalTable: "UserProfile",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Fare_UserProfile_DriverId",
                table: "Fare");

            migrationBuilder.DropForeignKey(
                name: "FK_Fare_UserProfile_PassengerId",
                table: "Fare");

            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId",
                table: "FareOffer");

            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId1",
                table: "FareOffer");

            migrationBuilder.DropForeignKey(
                name: "FK_Rating_UserProfile_FromId",
                table: "Rating");

            migrationBuilder.DropForeignKey(
                name: "FK_Rating_UserProfile_ToId",
                table: "Rating");

            migrationBuilder.DropIndex(
                name: "IX_FareOffer_UserVehicleId1",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "UserVehicleId1",
                table: "FareOffer");

            migrationBuilder.AlterColumn<int>(
                name: "UserVehicleId",
                table: "FareOffer",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddForeignKey(
                name: "FK_Fare_User_DriverId",
                table: "Fare",
                column: "DriverId",
                principalTable: "User",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Fare_User_PassengerId",
                table: "Fare",
                column: "PassengerId",
                principalTable: "User",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId",
                table: "FareOffer",
                column: "UserVehicleId",
                principalTable: "UserVehicle",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rating_User_FromId",
                table: "Rating",
                column: "FromId",
                principalTable: "User",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Rating_User_ToId",
                table: "Rating",
                column: "ToId",
                principalTable: "User",
                principalColumn: "Id");
        }
    }
}
