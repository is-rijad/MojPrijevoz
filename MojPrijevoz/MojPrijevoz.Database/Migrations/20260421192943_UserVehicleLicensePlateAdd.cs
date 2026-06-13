using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations {
    /// <inheritdoc />
    public partial class UserVehicleLicensePlateAdd : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "FuelConsumption",
                table: "UserVehicle");

            migrationBuilder.AddColumn<string>(
                name: "LicensePlate",
                table: "UserVehicle",
                type: "varchar(9)",
                unicode: false,
                maxLength: 9,
                nullable: false,
                defaultValue: "");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "LicensePlate",
                table: "UserVehicle");

            migrationBuilder.AddColumn<float>(
                name: "FuelConsumption",
                table: "UserVehicle",
                type: "real",
                nullable: false,
                defaultValue: 0f);
        }
    }
}
