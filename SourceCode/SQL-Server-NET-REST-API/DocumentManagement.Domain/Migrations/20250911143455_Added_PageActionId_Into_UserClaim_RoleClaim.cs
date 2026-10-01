using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations
{
    /// <inheritdoc />
    public partial class Added_PageActionId_Into_UserClaim_RoleClaim : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RoleClaims_Operations_OperationId",
                table: "RoleClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_UserClaims_Operations_OperationId",
                table: "UserClaims");

            migrationBuilder.AlterColumn<Guid>(
                name: "OperationId",
                table: "UserClaims",
                type: "uniqueidentifier",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier");

            migrationBuilder.AddColumn<Guid>(
                name: "PageActionId",
                table: "UserClaims",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AlterColumn<Guid>(
                name: "OperationId",
                table: "RoleClaims",
                type: "uniqueidentifier",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier");

            migrationBuilder.AddColumn<Guid>(
                name: "PageActionId",
                table: "RoleClaims",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.CreateIndex(
                name: "IX_UserClaims_PageActionId",
                table: "UserClaims",
                column: "PageActionId");

            migrationBuilder.CreateIndex(
                name: "IX_RoleClaims_PageActionId",
                table: "RoleClaims",
                column: "PageActionId");

            migrationBuilder.AddForeignKey(
                name: "FK_RoleClaims_Operations_OperationId",
                table: "RoleClaims",
                column: "OperationId",
                principalTable: "Operations",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_RoleClaims_PageActions_PageActionId",
                table: "RoleClaims",
                column: "PageActionId",
                principalTable: "PageActions",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserClaims_Operations_OperationId",
                table: "UserClaims",
                column: "OperationId",
                principalTable: "Operations",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserClaims_PageActions_PageActionId",
                table: "UserClaims",
                column: "PageActionId",
                principalTable: "PageActions",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_RoleClaims_Operations_OperationId",
                table: "RoleClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_RoleClaims_PageActions_PageActionId",
                table: "RoleClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_UserClaims_Operations_OperationId",
                table: "UserClaims");

            migrationBuilder.DropForeignKey(
                name: "FK_UserClaims_PageActions_PageActionId",
                table: "UserClaims");

            migrationBuilder.DropIndex(
                name: "IX_UserClaims_PageActionId",
                table: "UserClaims");

            migrationBuilder.DropIndex(
                name: "IX_RoleClaims_PageActionId",
                table: "RoleClaims");

            migrationBuilder.DropColumn(
                name: "PageActionId",
                table: "UserClaims");

            migrationBuilder.DropColumn(
                name: "PageActionId",
                table: "RoleClaims");

            migrationBuilder.AlterColumn<Guid>(
                name: "OperationId",
                table: "UserClaims",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldNullable: true);

            migrationBuilder.AlterColumn<Guid>(
                name: "OperationId",
                table: "RoleClaims",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_RoleClaims_Operations_OperationId",
                table: "RoleClaims",
                column: "OperationId",
                principalTable: "Operations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_UserClaims_Operations_OperationId",
                table: "UserClaims",
                column: "OperationId",
                principalTable: "Operations",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
