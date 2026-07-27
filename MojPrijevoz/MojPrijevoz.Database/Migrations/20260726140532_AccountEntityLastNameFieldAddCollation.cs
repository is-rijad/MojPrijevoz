using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class AccountEntityLastNameFieldAddCollation : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "LastName",
                table: "Account",
                type: "varchar(64)",
                unicode: false,
                maxLength: 64,
                nullable: false,
                collation: "Croatian_CI_AS",
                oldClrType: typeof(string),
                oldType: "varchar(64)",
                oldUnicode: false,
                oldMaxLength: 64);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "LastName",
                table: "Account",
                type: "varchar(64)",
                unicode: false,
                maxLength: 64,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(64)",
                oldUnicode: false,
                oldMaxLength: 64,
                oldCollation: "Croatian_CI_AS");
        }
    }
}
