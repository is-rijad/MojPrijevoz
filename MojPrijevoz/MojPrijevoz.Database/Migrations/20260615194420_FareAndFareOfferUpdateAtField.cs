using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class FareAndFareOfferUpdateAtField : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "FareOffer",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AddColumn<DateTime>(
                name: "UpdatedAt",
                table: "Fare",
                type: "datetime2",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "FareOffer");

            migrationBuilder.DropColumn(
                name: "UpdatedAt",
                table: "Fare");
        }
    }
}
