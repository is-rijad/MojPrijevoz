using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class GenderRemoveEmailUsernameAlter : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "Gender",
                table: "User");

            migrationBuilder.AlterColumn<string>(
                name: "Username",
                table: "Account",
                type: "varchar(96)",
                unicode: false,
                maxLength: 96,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Account",
                type: "varchar(96)",
                unicode: false,
                maxLength: 96,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(32)",
                oldUnicode: false,
                oldMaxLength: 32);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<short>(
                name: "Gender",
                table: "User",
                type: "smallint",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Username",
                table: "Account",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(96)",
                oldUnicode: false,
                oldMaxLength: 96);

            migrationBuilder.AlterColumn<string>(
                name: "Email",
                table: "Account",
                type: "varchar(32)",
                unicode: false,
                maxLength: 32,
                nullable: false,
                oldClrType: typeof(string),
                oldType: "varchar(96)",
                oldUnicode: false,
                oldMaxLength: 96);
        }
    }
}
