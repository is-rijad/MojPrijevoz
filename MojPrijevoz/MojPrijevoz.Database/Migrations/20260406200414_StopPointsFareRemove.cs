using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations {
    /// <inheritdoc />
    public partial class StopPointsFareRemove : Migration {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            migrationBuilder.DropForeignKey(
                name: "FK_StopPoint_Fare_FareId",
                table: "StopPoint");

            migrationBuilder.DropIndex(
                name: "IX_StopPoint_FareId",
                table: "StopPoint");

            migrationBuilder.DropColumn(
                name: "FareId",
                table: "StopPoint");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            migrationBuilder.AddColumn<int>(
                name: "FareId",
                table: "StopPoint",
                type: "int",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_StopPoint_FareId",
                table: "StopPoint",
                column: "FareId");

            migrationBuilder.AddForeignKey(
                name: "FK_StopPoint_Fare_FareId",
                table: "StopPoint",
                column: "FareId",
                principalTable: "Fare",
                principalColumn: "Id");
        }
    }
}
