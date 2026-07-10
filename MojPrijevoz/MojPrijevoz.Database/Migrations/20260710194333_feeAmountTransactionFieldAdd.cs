using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace MojPrijevoz.Database.Migrations
{
    /// <inheritdoc />
    public partial class feeAmountTransactionFieldAdd : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<float>(
                name: "FeeAmount",
                table: "Transaction",
                type: "real",
                nullable: true);
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "FeeAmount",
                table: "Transaction");
        }
    }
}
