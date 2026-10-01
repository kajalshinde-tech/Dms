using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations
{
    /// <inheritdoc />
    public partial class Version_V31 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.AddColumn<int>(
                name: "NotificationsType",
                table: "UserNotifications",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddColumn<string>(
                name: "FromName",
                table: "SendEmails",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ToName",
                table: "SendEmails",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "OrderNo",
                table: "Screens",
                type: "int",
                nullable: true);

            migrationBuilder.AlterColumn<DateTime>(
                name: "Logged",
                table: "NLog",
                type: "datetime2",
                nullable: false,
                defaultValueSql: "GETUTCDATE()",
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddColumn<byte[]>(
                name: "IV",
                table: "DocumentVersions",
                type: "VARBINARY(MAX)",
                nullable: true);

            migrationBuilder.AddColumn<byte[]>(
                name: "Key",
                table: "DocumentVersions",
                type: "VARBINARY(MAX)",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DocumentStatusId",
                table: "Documents",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<byte[]>(
                name: "IV",
                table: "Documents",
                type: "VARBINARY(MAX)",
                nullable: true);

            migrationBuilder.AddColumn<byte[]>(
                name: "Key",
                table: "Documents",
                type: "VARBINARY(MAX)",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "StorageSettingId",
                table: "Documents",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<int>(
                name: "StorageType",
                table: "Documents",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.CreateTable(
                name: "CompanyProfiles",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LogoUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    BannerUrl = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DeletedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_CompanyProfiles", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "DocumentShareableLinks",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DocumentId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    LinkExpiryTime = table.Column<DateTime>(type: "datetime", nullable: true),
                    Password = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    LinkCode = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsLinkExpired = table.Column<bool>(type: "bit", nullable: false),
                    IsAllowDownload = table.Column<bool>(type: "bit", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DeletedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DocumentShareableLinks", x => x.Id);
                    table.ForeignKey(
                        name: "FK_DocumentShareableLinks_Documents_DocumentId",
                        column: x => x.DocumentId,
                        principalTable: "Documents",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "DocumentStatuses",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    ColorCode = table.Column<string>(type: "nvarchar(max)", nullable: true)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_DocumentStatuses", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "PageHelpers",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Code = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DeletedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_PageHelpers", x => x.Id);
                });

            migrationBuilder.CreateTable(
                name: "StorageSettings",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    JsonValue = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsDefault = table.Column<bool>(type: "bit", nullable: false),
                    EnableEncryption = table.Column<bool>(type: "bit", nullable: false),
                    StorageType = table.Column<int>(type: "int", nullable: false),
                    CreatedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    CreatedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    ModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: false),
                    ModifiedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    DeletedDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    DeletedBy = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
                    IsDeleted = table.Column<bool>(type: "bit", nullable: false)
                },
                constraints: table =>
                {
                    table.PrimaryKey("PK_StorageSettings", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_Documents_DocumentStatusId",
                table: "Documents",
                column: "DocumentStatusId");

            migrationBuilder.CreateIndex(
                name: "IX_Documents_StorageSettingId",
                table: "Documents",
                column: "StorageSettingId");

            migrationBuilder.CreateIndex(
                name: "IX_DocumentShareableLinks_DocumentId",
                table: "DocumentShareableLinks",
                column: "DocumentId");

            migrationBuilder.AddForeignKey(
                name: "FK_Documents_DocumentStatuses_DocumentStatusId",
                table: "Documents",
                column: "DocumentStatusId",
                principalTable: "DocumentStatuses",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_Documents_StorageSettings_StorageSettingId",
                table: "Documents",
                column: "StorageSettingId",
                principalTable: "StorageSettings",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Documents_DocumentStatuses_DocumentStatusId",
                table: "Documents");

            migrationBuilder.DropForeignKey(
                name: "FK_Documents_StorageSettings_StorageSettingId",
                table: "Documents");

            migrationBuilder.DropTable(
                name: "CompanyProfiles");

            migrationBuilder.DropTable(
                name: "DocumentShareableLinks");

            migrationBuilder.DropTable(
                name: "DocumentStatuses");

            migrationBuilder.DropTable(
                name: "PageHelpers");

            migrationBuilder.DropTable(
                name: "StorageSettings");

            migrationBuilder.DropIndex(
                name: "IX_Documents_DocumentStatusId",
                table: "Documents");

            migrationBuilder.DropIndex(
                name: "IX_Documents_StorageSettingId",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "NotificationsType",
                table: "UserNotifications");

            migrationBuilder.DropColumn(
                name: "FromName",
                table: "SendEmails");

            migrationBuilder.DropColumn(
                name: "ToName",
                table: "SendEmails");

            migrationBuilder.DropColumn(
                name: "OrderNo",
                table: "Screens");

            migrationBuilder.DropColumn(
                name: "IV",
                table: "DocumentVersions");

            migrationBuilder.DropColumn(
                name: "Key",
                table: "DocumentVersions");

            migrationBuilder.DropColumn(
                name: "DocumentStatusId",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "IV",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "Key",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "StorageSettingId",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "StorageType",
                table: "Documents");

            migrationBuilder.AlterColumn<string>(
                name: "Logged",
                table: "NLog",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(DateTime),
                oldType: "datetime2",
                oldDefaultValueSql: "GETUTCDATE()");
        }
    }
}
