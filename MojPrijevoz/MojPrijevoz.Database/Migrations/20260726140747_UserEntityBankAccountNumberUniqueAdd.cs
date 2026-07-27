using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class UserEntityBankAccountNumberUniqueAdd : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_User_BankAccountNumber",
                table: "User",
                column: "BankAccountNumber",
                unique: true,
                filter: "[BankAccountNumber] IS NOT NULL");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropIndex(
                name: "IX_User_BankAccountNumber",
                table: "User");
        }
    }
}
