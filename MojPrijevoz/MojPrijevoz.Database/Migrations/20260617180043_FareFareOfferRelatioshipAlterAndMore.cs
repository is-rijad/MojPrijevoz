using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareFareOfferRelatioshipAlterAndMore : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Fare_FareDataId",
                table: "Fare");

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "Vehicle",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "UserFcmTokens",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "FareOffer",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "Fare",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "City",
                type: "datetime2",
                nullable: false,
                defaultValue: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified),
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldNullable: true);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 1,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 2,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 3,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 4,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 5,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 6,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 7,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 8,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 9,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 10,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 11,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 12,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 13,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 14,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 15,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 16,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 17,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 18,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 19,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 20,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 21,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 22,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 23,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 24,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 25,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 26,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 27,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 28,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 29,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 30,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 31,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 32,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 33,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 34,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 35,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 36,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 37,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 38,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 39,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 40,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 41,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 42,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 43,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 44,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 45,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 46,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 47,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 48,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 49,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 50,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 51,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 52,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 53,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 54,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 55,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 56,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 57,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 58,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 59,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 60,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 61,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 62,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 63,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 64,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 65,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 66,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 67,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 68,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 69,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 70,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 71,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 72,
                column: "UpdatedAt",
                value: new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified));

            migrationBuilder.CreateIndex(
                name: "IX_Fare_FareDataId",
                table: "Fare",
                column: "FareDataId");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_Fare_FareDataId",
                table: "Fare");

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "Vehicle",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "UserFcmTokens",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "FareOffer",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "Fare",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.AlterColumn<DateTime>(
                name: "UpdatedAt",
                table: "City",
                type: "datetime2",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2");

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 1,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 2,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 3,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 4,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 5,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 6,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 7,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 8,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 9,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 10,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 11,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 12,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 13,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 14,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 15,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 16,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 17,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 18,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 19,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 20,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 21,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 22,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 23,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 24,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 25,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 26,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 27,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 28,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 29,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 30,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 31,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 32,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 33,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 34,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 35,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 36,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 37,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 38,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 39,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 40,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 41,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 42,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 43,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 44,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 45,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 46,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 47,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 48,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 49,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 50,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 51,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 52,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 53,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 54,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 55,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 56,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 57,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 58,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 59,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 60,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 61,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 62,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 63,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 64,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 65,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 66,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 67,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 68,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 69,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 70,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 71,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.UpdateData(
                table: "City",
                keyColumn: "Id",
                keyValue: 72,
                column: "UpdatedAt",
                value: null);

            migrationBuilder.CreateIndex(
                name: "IX_Fare_FareDataId",
                table: "Fare",
                column: "FareDataId",
                unique: true);
        }
    }
}
