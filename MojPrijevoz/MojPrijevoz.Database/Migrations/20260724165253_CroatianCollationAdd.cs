using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class CroatianCollationAdd : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Model",
                table: "Vehicle",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                collation: "Croatian_CI_AS",
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32);

            migrationBuilder.AlterColumn<string>(
                name: "Manufacturer",
                table: "Vehicle",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                collation: "Croatian_CI_AS",
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "City",
                type: "nvarchar(32)",
                maxLength: 32,
                nullable: false,
                collation: "Croatian_CI_AS",
                oldClrType: typeof(string),
                oldType: "nvarchar(32)",
                oldMaxLength: 32);

            migrationBuilder.AlterColumn<string>(
                name: "Username",
                table: "Account",
                type: "varchar(96)",
                unicode: false,
                maxLength: 96,
                nullable: false,
                collation: "Croatian_CI_AS",
                oldClrType: typeof(string),
                oldType: "varchar(96)",
                oldUnicode: false,
                oldMaxLength: 96);

            migrationBuilder.AlterColumn<string>(
                name: "FirstName",
                table: "Account",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                collation: "Croatian_CI_AS",
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AlterColumn<string>(
                name: "Model",
                table: "Vehicle",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32,
                oldCollation: "Croatian_CI_AS");

            migrationBuilder.AlterColumn<string>(
                name: "Manufacturer",
                table: "Vehicle",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32,
                oldCollation: "Croatian_CI_AS");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "City",
                type: "nvarchar(32)",
                maxLength: 32,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "nvarchar(32)",
                oldMaxLength: 32,
                oldCollation: "Croatian_CI_AS");

            migrationBuilder.AlterColumn<string>(
                name: "Username",
                table: "Account",
                type: "varchar(96)",
                unicode: false,
                maxLength: 96,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(96)",
                oldUnicode: false,
                oldMaxLength: 96,
                oldCollation: "Croatian_CI_AS");

            migrationBuilder.AlterColumn<string>(
                name: "FirstName",
                table: "Account",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32,
                oldCollation: "Croatian_CI_AS");
        }
    }
}
