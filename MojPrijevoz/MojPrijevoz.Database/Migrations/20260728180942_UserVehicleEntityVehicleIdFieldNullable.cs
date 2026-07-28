using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class UserVehicleEntityVehicleIdFieldNullable : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserVehicle_Vehicle_VehicleId",
                table: "UserVehicle");

            migrationBuilder.DropIndex(
                name: "IX_UserVehicle_ProfileId_VehicleId_ModelYear",
                table: "UserVehicle");

            migrationBuilder.AlterColumn<int>(
                name: "VehicleId",
                table: "UserVehicle",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.CreateIndex(
                name: "IX_UserVehicle_ProfileId_VehicleId_ModelYear",
                table: "UserVehicle",
                columns: new[] { "ProfileId", "VehicleId", "ModelYear" },
                unique: true,
                filter: "[VehicleId] IS NOT NULL");

            migrationBuilder.AddForeignKey(
                name: "FK_UserVehicle_Vehicle_VehicleId",
                table: "UserVehicle",
                column: "VehicleId",
                principalTable: "Vehicle",
                principalColumn: "Id",
                onDelete: ReferentialAction.SetNull);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserVehicle_Vehicle_VehicleId",
                table: "UserVehicle");

            migrationBuilder.DropIndex(
                name: "IX_UserVehicle_ProfileId_VehicleId_ModelYear",
                table: "UserVehicle");

            migrationBuilder.AlterColumn<int>(
                name: "VehicleId",
                table: "UserVehicle",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserVehicle_ProfileId_VehicleId_ModelYear",
                table: "UserVehicle",
                columns: new[] { "ProfileId", "VehicleId", "ModelYear" },
                unique: true);

            migrationBuilder.AddForeignKey(
                name: "FK_UserVehicle_Vehicle_VehicleId",
                table: "UserVehicle",
                column: "VehicleId",
                principalTable: "Vehicle",
                principalColumn: "Id");
        }
    }
}
