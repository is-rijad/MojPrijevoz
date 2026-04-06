using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareDataEntityAdd : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Fare_City_OriginCityId",
                table: "Fare");

            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer");

            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId1",
                table: "FareOffer");

            migrationBuilder.DropIndex(
                name: "IX_StopPoint_FareId_Order",
                table: "StopPoint");

            migrationBuilder.DropIndex(
                name: "IX_FareOffer_UserVehicleId1",
                table: "FareOffer");

            migrationBuilder.DropIndex(
                name: "IX_Fare_OriginCityId",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "UserVehicleId1",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "DestinationLat",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "DestinationLong",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "Duration",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "FareDateTime",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "Length",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "Price",
                table: "Fare");

            migrationBuilder.RenameColumn(
                name: "OriginCityId",
                table: "Fare",
                newName: "FareDataId");

            migrationBuilder.AlterColumn<int>(
                name: "FareId",
                table: "StopPoint",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "FareDataId",
                table: "StopPoint",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AlterColumn<int>(
                name: "FareId",
                table: "FareOffer",
                type: "int",
                nullable: true,
                oldClrType: typeof(int),
                oldType: "int");

            migrationBuilder.AddColumn<int>(
                name: "FareDataId",
                table: "FareOffer",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "FareData",
                columns: table => new
                {
                    Id = table.Column<int>(type: "int", nullable: false)
                        .Annotation("SqlServer:Identity", "1, 1"),
                    OriginCityId = table.Column<int>(type: "int", nullable: false),
                    DestinationLat = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    DestinationLong = table.Column<string>(type: "nvarchar(max)", nullable: false),
                    Length = table.Column<int>(type: "int", nullable: false),
                    Duration = table.Column<int>(type: "int", nullable: false),
                    FareDateTime = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedAt = table.Column<DateTime>(type: "datetime2", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_FareData", x => x.Id);
                    table.ForeignKey(
                        name: "FK_FareData_City_OriginCityId",
                        column: x => x.OriginCityId,
                        principalTable: "City",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateIndex(
                name: "IX_StopPoint_FareDataId_Order",
                table: "StopPoint",
                columns: new[] { "FareDataId", "Order" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_StopPoint_FareId",
                table: "StopPoint",
                column: "FareId");

            migrationBuilder.CreateIndex(
                name: "IX_FareOffer_FareDataId",
                table: "FareOffer",
                column: "FareDataId");

            migrationBuilder.CreateIndex(
                name: "IX_Fare_FareDataId",
                table: "Fare",
                column: "FareDataId",
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_FareData_OriginCityId",
                table: "FareData",
                column: "OriginCityId");

            migrationBuilder.AddForeignKey(
                name: "FK_Fare_FareData_FareDataId",
                table: "Fare",
                column: "FareDataId",
                principalTable: "FareData",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_FareData_FareDataId",
                table: "FareOffer",
                column: "FareDataId",
                principalTable: "FareData",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer",
                column: "FareId",
                principalTable: "Fare",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_StopPoint_FareData_FareDataId",
                table: "StopPoint",
                column: "FareDataId",
                principalTable: "FareData",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Fare_FareData_FareDataId",
                table: "Fare");

            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_FareData_FareDataId",
                table: "FareOffer");

            migrationBuilder.DropForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer");

            migrationBuilder.DropForeignKey(
                name: "FK_StopPoint_FareData_FareDataId",
                table: "StopPoint");

            migrationBuilder.DropTable(
                name: "FareData");

            migrationBuilder.DropIndex(
                name: "IX_StopPoint_FareDataId_Order",
                table: "StopPoint");

            migrationBuilder.DropIndex(
                name: "IX_StopPoint_FareId",
                table: "StopPoint");

            migrationBuilder.DropIndex(
                name: "IX_FareOffer_FareDataId",
                table: "FareOffer");

            migrationBuilder.DropIndex(
                name: "IX_Fare_FareDataId",
                table: "Fare");

            migrationBuilder.DropColumn(
                name: "FareDataId",
                table: "StopPoint");

            migrationBuilder.DropColumn(
                name: "FareDataId",
                table: "FareOffer");

            migrationBuilder.RenameColumn(
                name: "FareDataId",
                table: "Fare",
                newName: "OriginCityId");

            migrationBuilder.AlterColumn<int>(
                name: "FareId",
                table: "StopPoint",
                type: "int",
                nullable: false,
                defaultValue: 0,
                oldClrType: typeof(int),
                oldType: "int",
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "FareId",
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

            migrationBuilder.AddColumn<string>(
                name: "DestinationLat",
                table: "Fare",
                type: "varchar(16)",
                unicode: false,
                maxLength: 16,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<string>(
                name: "DestinationLong",
                table: "Fare",
                type: "varchar(16)",
                unicode: false,
                maxLength: 16,
                nullable: false,
                defaultValue: "");

            migrationBuilder.AddColumn<int>(
                name: "Duration",
                table: "Fare",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<DateTime>(
                name: "FareDateTime",
                table: "Fare",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.AddColumn<int>(
                name: "Length",
                table: "Fare",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<float>(
                name: "Price",
                table: "Fare",
                type: "real",
                nullable: false,
                defaultValue: 0f);

            migrationBuilder.CreateIndex(
                name: "IX_StopPoint_FareId_Order",
                table: "StopPoint",
                columns: new[] { "FareId", "Order" },
                unique: true);

            migrationBuilder.CreateIndex(
                name: "IX_FareOffer_UserVehicleId1",
                table: "FareOffer",
                column: "UserVehicleId1");

            migrationBuilder.CreateIndex(
                name: "IX_Fare_OriginCityId",
                table: "Fare",
                column: "OriginCityId");

            migrationBuilder.AddForeignKey(
                name: "FK_Fare_City_OriginCityId",
                table: "Fare",
                column: "OriginCityId",
                principalTable: "City",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_Fare_FareId",
                table: "FareOffer",
                column: "FareId",
                principalTable: "Fare",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_FareOffer_UserVehicle_UserVehicleId1",
                table: "FareOffer",
                column: "UserVehicleId1",
                principalTable: "UserVehicle",
                principalColumn: "Id");
        }
    }
}
