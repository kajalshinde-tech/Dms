using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations
{
    /// <inheritdoc />
    public partial class Version_V8 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropColumn(
                name: "IsUnreadComment",
                table: "DocumentComments");

            migrationBuilder.AddColumn<int>(
                name: "OrderNo",
                table: "WorkflowSteps",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<bool>(
                name: "IsSystemUser",
                table: "Users",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AlterColumn<decimal>(
                name: "Creativity",
                table: "UserOpenaiMsgs",
                type: "decimal(18,2)",
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "decimal(18,6)",
                oldPrecision: 18,
                oldScale: 6);

            migrationBuilder.AddColumn<Guid>(
                name: "ArchiveById",
                table: "Documents",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "OnExpiryAction",
                table: "Documents",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<DateOnly>(
                name: "RetentionDate",
                table: "Documents",
                type: "date",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "RetentionPeriodInDays",
                table: "Documents",
                type: "int",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DocumentId",
                table: "DocumentIndexes",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<string>(
                name: "LicenseKey",
                table: "CompanyProfiles",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "PurchaseCode",
                table: "CompanyProfiles",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "ArchiveById",
                table: "Categories",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.CreateTable(
                name: "ArchiveRetentions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RetentionPeriodInDays = table.Column<int>(type: "int", nullable: true),
                    IsEnabled = table.Column<bool>(type: "bit", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: false, defaultValueSql: "GETUTCDATE()"),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DeletedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_ArchiveRetentions", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Documents_ArchiveById",
                table: "Documents",
                column: "ArchiveById");

            migrationBuilder.CreateIndex(
                name: "IX_Categories_ArchiveById",
                table: "Categories",
                column: "ArchiveById");

            migrationBuilder.AddForeignKey(
                name: "FK_Categories_Users_ArchiveById",
                table: "Categories",
                column: "ArchiveById",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Documents_Users_ArchiveById",
                table: "Documents",
                column: "ArchiveById",
                principalTable: "Users",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Categories_Users_ArchiveById",
                table: "Categories");

            migrationBuilder.DropForeignKey(
                name: "FK_Documents_Users_ArchiveById",
                table: "Documents");

            migrationBuilder.DropTable(
                name: "ArchiveRetentions");

            migrationBuilder.DropIndex(
                name: "IX_Documents_ArchiveById",
                table: "Documents");

            migrationBuilder.DropIndex(
                name: "IX_Categories_ArchiveById",
                table: "Categories");

            migrationBuilder.DropColumn(
                name: "OrderNo",
                table: "WorkflowSteps");

            migrationBuilder.DropColumn(
                name: "IsSystemUser",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "ArchiveById",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "OnExpiryAction",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "RetentionDate",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "RetentionPeriodInDays",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "DocumentId",
                table: "DocumentIndexes");

            migrationBuilder.DropColumn(
                name: "LicenseKey",
                table: "CompanyProfiles");

            migrationBuilder.DropColumn(
                name: "PurchaseCode",
                table: "CompanyProfiles");

            migrationBuilder.DropColumn(
                name: "ArchiveById",
                table: "Categories");

            migrationBuilder.AlterColumn<decimal>(
                name: "Creativity",
                table: "UserOpenaiMsgs",
                type: "decimal(18,6)",
                precision: 18,
                scale: 6,
                nullable: false,
                oldClrType: typeof(decimal),
                oldType: "decimal(18,2)");

            migrationBuilder.AddColumn<bool>(
                name: "IsUnreadComment",
                table: "DocumentComments",
                type: "bit",
                nullable: false,
                defaultValue: false);
        }
    }
}
