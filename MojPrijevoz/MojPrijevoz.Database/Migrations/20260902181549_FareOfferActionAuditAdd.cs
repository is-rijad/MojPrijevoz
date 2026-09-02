using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareOfferActionAuditAdd : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "ActionAt",
                table: "FareOffer",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "ActionByUserId",
                table: "FareOffer",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ActionReason",
                table: "FareOffer",
                type: "nvarchar(500)",
                maxLength: 500,
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "ActionAt",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "ActionByUserId",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "ActionReason",
                table: "FareOffer");
        }
    }
}
