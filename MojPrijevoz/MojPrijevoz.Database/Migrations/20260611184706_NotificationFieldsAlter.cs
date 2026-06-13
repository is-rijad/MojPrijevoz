using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations {
    /// <inheritdoc />
    public partial class NotificationFieldsAlter : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<int>(
                name: "FareId",
                table: "Notifications",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<short>(
                name: "Side",
                table: "Notifications",
                type: "smallint",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropColumn(
                name: "FareId",
                table: "Notifications");

            migrationBuilder.DropColumn(
                name: "Side",
                table: "Notifications");
        }
    }
}
