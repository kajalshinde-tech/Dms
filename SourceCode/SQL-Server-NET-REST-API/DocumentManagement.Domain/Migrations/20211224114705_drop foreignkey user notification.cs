using Microsoft.EntityFrameworkCore.Migrations;

namespace DocumentManagement.Domain.Migrations
{
    public partial class dropforeignkeyusernotification : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_UserNotifications_Users_CreatedBy",
                table: "UserNotifications");

            migrationBuilder.DropIndex(
                name: "IX_UserNotifications_CreatedBy",
                table: "UserNotifications");
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.CreateIndex(
                name: "IX_UserNotifications_CreatedBy",
                table: "UserNotifications",
                column: "CreatedBy");

            migrationBuilder.AddForeignKey(
                name: "FK_UserNotifications_Users_CreatedBy",
                table: "UserNotifications",
                column: "CreatedBy",
                principalTable: "Users",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
