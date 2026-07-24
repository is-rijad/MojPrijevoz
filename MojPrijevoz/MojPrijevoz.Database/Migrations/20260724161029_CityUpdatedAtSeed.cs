using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations {
    /// <inheritdoc />
    public partial class CityUpdatedAtSeed : Migration {
        private static readonly DateTime SeedDate = new DateTime(2026, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);
        private static readonly DateTime DefaultDate = new DateTime(1, 1, 1, 0, 0, 0, 0, DateTimeKind.Unspecified);

        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder) {
            for (int id = 1; id <= 72; id++) {
                migrationBuilder.UpdateData(
                    table: "City",
                    keyColumn: "Id",
                    keyValue: id,
                    column: "UpdatedAt",
                    value: SeedDate);
            }
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder) {
            for (int id = 1; id <= 72; id++) {
                migrationBuilder.UpdateData(
                    table: "City",
                    keyColumn: "Id",
                    keyValue: id,
                    column: "UpdatedAt",
                    value: DefaultDate);
            }
        }
    }
}