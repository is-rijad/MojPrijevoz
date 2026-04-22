using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareDataAdd : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FareData_City_OriginCityId",
                table: "FareData");

            migrationBuilder.AlterColumn<string>(
                name: "DestinationLong",
                table: "FareData",
                type: "varchar(16)",
                unicode: false,
                maxLength: 16,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AlterColumn<string>(
                name: "DestinationLat",
                table: "FareData",
                type: "varchar(16)",
                unicode: false,
                maxLength: 16,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)");

            migrationBuilder.AddForeignKey(
                name: "FK_FareData_City_OriginCityId",
                table: "FareData",
                column: "OriginCityId",
                principalTable: "City",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_FareData_City_OriginCityId",
                table: "FareData");

            migrationBuilder.AlterColumn<string>(
                name: "DestinationLong",
                table: "FareData",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(16)",
                oldUnicode: false,
                oldMaxLength: 16);

            migrationBuilder.AlterColumn<string>(
                name: "DestinationLat",
                table: "FareData",
                type: "nvarchar(max)",
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(16)",
                oldUnicode: false,
                oldMaxLength: 16);

            migrationBuilder.AddForeignKey(
                name: "FK_FareData_City_OriginCityId",
                table: "FareData",
                column: "OriginCityId",
                principalTable: "City",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
