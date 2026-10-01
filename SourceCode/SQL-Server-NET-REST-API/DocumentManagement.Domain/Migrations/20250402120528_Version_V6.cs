using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations
{
    /// <inheritdoc />
    public partial class Version_V6 : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_DocumentChunk_DocumentVersions_DocumentVersionId",
                table: "DocumentChunk");

            migrationBuilder.DropForeignKey(
                name: "FK_DocumentIndexes_Documents_DocumentId",
                table: "DocumentIndexes");

            migrationBuilder.DropPrimaryKey(
                name: "PK_DocumentChunk",
                table: "DocumentChunk");

            migrationBuilder.RenameTable(
                name: "DocumentChunk",
                newName: "DocumentChunks");

            migrationBuilder.RenameColumn(
                name: "DocumentId",
                table: "DocumentIndexes",
                newName: "DocumentVersionId");

            migrationBuilder.RenameIndex(
                name: "IX_DocumentIndexes_DocumentId",
                table: "DocumentIndexes",
                newName: "IX_DocumentIndexes_DocumentVersionId");

            migrationBuilder.RenameIndex(
                name: "IX_DocumentChunk_DocumentVersionId",
                table: "DocumentChunks",
                newName: "IX_DocumentChunks_DocumentVersionId");

            migrationBuilder.AddColumn<string>(
                name: "ClientId",
                table: "Users",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<string>(
                name: "ClientSecretHash",
                table: "Users",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "CategoryId",
                table: "UserNotifications",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Documents",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddColumn<string>(
                name: "DocumentNumber",
                table: "Documents",
                type: "nvarchar(max)",
                nullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "DocumentMetaTagId",
                table: "DocumentMetaDatas",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"));

            migrationBuilder.AddColumn<DateTime>(
                name: "MetaTagDate",
                table: "DocumentMetaDatas",
                type: "datetime2",
                nullable: true);

            migrationBuilder.AlterColumn<Guid>(
                name: "DocumentId",
                table: "DocumentAuditTrails",
                type: "uniqueidentifier",
                nullable: true,
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier");

            migrationBuilder.AddColumn<Guid>(
                name: "CategoryId",
                table: "DocumentAuditTrails",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsArchive",
                table: "CustomCategories",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Categories",
                type: "nvarchar(450)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(max)",
                oldNullable: true);

            migrationBuilder.AddColumn<Guid>(
                name: "ArchiveParentId",
                table: "Categories",
                type: "uniqueidentifier",
                nullable: true);

            migrationBuilder.AddColumn<bool>(
                name: "IsArchive",
                table: "Categories",
                type: "bit",
                nullable: false,
                defaultValue: false);

            migrationBuilder.AddColumn<int>(
                name: "TotalChunk",
                table: "DocumentChunks",
                type: "int",
                nullable: false,
                defaultValue: 0);

            migrationBuilder.AddPrimaryKey(
                name: "PK_DocumentChunks",
                table: "DocumentChunks",
                column: "Id");

            migrationBuilder.CreateTable(
                name: "CategoryRolePermissions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CategoryId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsTimeBound = table.Column<bool>(type: "bit", nullable: false),
                    IsAllowDownload = table.Column<bool>(type: "bit", nullable: false),
                    ParentId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
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
                    table.PrimaryKey("PK_CategoryRolePermissions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CategoryRolePermissions_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CategoryRolePermissions_Roles_RoleId",
                        column: x => x.RoleId,
                        principalTable: "Roles",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CategoryRolePermissions_Users_CreatedBy",
                        column: x => x.CreatedBy,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                });

            migrationBuilder.CreateTable(
                name: "CategoryUserPermissions",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    CategoryId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    StartDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    EndDate = table.Column<DateTime>(type: "datetime2", nullable: true),
                    IsTimeBound = table.Column<bool>(type: "bit", nullable: false),
                    IsAllowDownload = table.Column<bool>(type: "bit", nullable: false),
                    ParentId = table.Column<Guid>(type: "uniqueidentifier", nullable: true),
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
                    table.PrimaryKey("PK_CategoryUserPermissions", x => x.Id);
                    table.ForeignKey(
                        name: "FK_CategoryUserPermissions_Categories_CategoryId",
                        column: x => x.CategoryId,
                        principalTable: "Categories",
                        principalColumn: "Id");
                    table.ForeignKey(
                        name: "FK_CategoryUserPermissions_Users_CreatedBy",
                        column: x => x.CreatedBy,
                        principalTable: "Users",
                        principalColumn: "Id",
                        onDelete: ReferentialAction.Cascade);
                    table.ForeignKey(
                        name: "FK_CategoryUserPermissions_Users_UserId",
                        column: x => x.UserId,
                        principalTable: "Users",
                        principalColumn: "Id");
                });

            migrationBuilder.CreateTable(
                name: "DocumentMetaTags",
                columns: table => new
                {
                    Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                    Type = table.Column<int>(type: "int", nullable: false),
                    Name = table.Column<string>(type: "nvarchar(max)", nullable: true),
                    IsEditable = table.Column<bool>(type: "bit", nullable: false),
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
                    table.PrimaryKey("PK_DocumentMetaTags", x => x.Id);
                });

            migrationBuilder.CreateIndex(
                name: "IX_UserNotifications_CategoryId",
                table: "UserNotifications",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Documents_Name_CategoryId_IsArchive_IsDeleted",
                table: "Documents",
                columns: new[] { "Name", "CategoryId", "IsArchive", "IsDeleted" },
                unique: true,
                filter: "[Name] IS NOT NULL");

            migrationBuilder.CreateIndex(
                name: "IX_DocumentMetaDatas_DocumentMetaTagId",
                table: "DocumentMetaDatas",
                column: "DocumentMetaTagId");

            migrationBuilder.CreateIndex(
                name: "IX_DocumentAuditTrails_CategoryId",
                table: "DocumentAuditTrails",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_Categories_CreatedBy",
                table: "Categories",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_Categories_Name_ParentId_IsArchive_IsDeleted",
                table: "Categories",
                columns: new[] { "Name", "ParentId", "IsArchive", "IsDeleted" });

            migrationBuilder.CreateIndex(
                name: "IX_CategoryRolePermissions_CategoryId",
                table: "CategoryRolePermissions",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_CategoryRolePermissions_CreatedBy",
                table: "CategoryRolePermissions",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_CategoryRolePermissions_RoleId",
                table: "CategoryRolePermissions",
                column: "RoleId");

            migrationBuilder.CreateIndex(
                name: "IX_CategoryUserPermissions_CategoryId",
                table: "CategoryUserPermissions",
                column: "CategoryId");

            migrationBuilder.CreateIndex(
                name: "IX_CategoryUserPermissions_CreatedBy",
                table: "CategoryUserPermissions",
                column: "CreatedBy");

            migrationBuilder.CreateIndex(
                name: "IX_CategoryUserPermissions_UserId",
                table: "CategoryUserPermissions",
                column: "UserId");

            migrationBuilder.AddForeignKey(
                name: "FK_Categories_Users_CreatedBy",
                table: "Categories",
                column: "CreatedBy",
                principalTable: "Users",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_DocumentAuditTrails_Categories_CategoryId",
                table: "DocumentAuditTrails",
                column: "CategoryId",
                principalTable: "Categories",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_DocumentChunks_DocumentVersions_DocumentVersionId",
                table: "DocumentChunks",
                column: "DocumentVersionId",
                principalTable: "DocumentVersions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DocumentIndexes_DocumentVersions_DocumentVersionId",
                table: "DocumentIndexes",
                column: "DocumentVersionId",
                principalTable: "DocumentVersions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DocumentMetaDatas_DocumentMetaTags_DocumentMetaTagId",
                table: "DocumentMetaDatas",
                column: "DocumentMetaTagId",
                principalTable: "DocumentMetaTags",
                principalColumn: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_UserNotifications_Categories_CategoryId",
                table: "UserNotifications",
                column: "CategoryId",
                principalTable: "Categories",
                principalColumn: "Id");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Categories_Users_CreatedBy",
                table: "Categories");

            migrationBuilder.DropForeignKey(
                name: "FK_DocumentAuditTrails_Categories_CategoryId",
                table: "DocumentAuditTrails");

            migrationBuilder.DropForeignKey(
                name: "FK_DocumentChunks_DocumentVersions_DocumentVersionId",
                table: "DocumentChunks");

            migrationBuilder.DropForeignKey(
                name: "FK_DocumentIndexes_DocumentVersions_DocumentVersionId",
                table: "DocumentIndexes");

            migrationBuilder.DropForeignKey(
                name: "FK_DocumentMetaDatas_DocumentMetaTags_DocumentMetaTagId",
                table: "DocumentMetaDatas");

            migrationBuilder.DropForeignKey(
                name: "FK_UserNotifications_Categories_CategoryId",
                table: "UserNotifications");

            migrationBuilder.DropTable(
                name: "CategoryRolePermissions");

            migrationBuilder.DropTable(
                name: "CategoryUserPermissions");

            migrationBuilder.DropTable(
                name: "DocumentMetaTags");

            migrationBuilder.DropIndex(
                name: "IX_UserNotifications_CategoryId",
                table: "UserNotifications");

            migrationBuilder.DropIndex(
                name: "IX_Documents_Name_CategoryId_IsArchive_IsDeleted",
                table: "Documents");

            migrationBuilder.DropIndex(
                name: "IX_DocumentMetaDatas_DocumentMetaTagId",
                table: "DocumentMetaDatas");

            migrationBuilder.DropIndex(
                name: "IX_DocumentAuditTrails_CategoryId",
                table: "DocumentAuditTrails");

            migrationBuilder.DropIndex(
                name: "IX_Categories_CreatedBy",
                table: "Categories");

            migrationBuilder.DropIndex(
                name: "IX_Categories_Name_ParentId_IsArchive_IsDeleted",
                table: "Categories");

            migrationBuilder.DropPrimaryKey(
                name: "PK_DocumentChunks",
                table: "DocumentChunks");

            migrationBuilder.DropColumn(
                name: "ClientId",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "ClientSecretHash",
                table: "Users");

            migrationBuilder.DropColumn(
                name: "CategoryId",
                table: "UserNotifications");

            migrationBuilder.DropColumn(
                name: "DocumentNumber",
                table: "Documents");

            migrationBuilder.DropColumn(
                name: "DocumentMetaTagId",
                table: "DocumentMetaDatas");

            migrationBuilder.DropColumn(
                name: "MetaTagDate",
                table: "DocumentMetaDatas");

            migrationBuilder.DropColumn(
                name: "CategoryId",
                table: "DocumentAuditTrails");

            migrationBuilder.DropColumn(
                name: "IsArchive",
                table: "CustomCategories");

            migrationBuilder.DropColumn(
                name: "ArchiveParentId",
                table: "Categories");

            migrationBuilder.DropColumn(
                name: "IsArchive",
                table: "Categories");

            migrationBuilder.DropColumn(
                name: "TotalChunk",
                table: "DocumentChunks");

            migrationBuilder.RenameTable(
                name: "DocumentChunks",
                newName: "DocumentChunk");

            migrationBuilder.RenameColumn(
                name: "DocumentVersionId",
                table: "DocumentIndexes",
                newName: "DocumentId");

            migrationBuilder.RenameIndex(
                name: "IX_DocumentIndexes_DocumentVersionId",
                table: "DocumentIndexes",
                newName: "IX_DocumentIndexes_DocumentId");

            migrationBuilder.RenameIndex(
                name: "IX_DocumentChunks_DocumentVersionId",
                table: "DocumentChunk",
                newName: "IX_DocumentChunk_DocumentVersionId");

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Documents",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AlterColumn<Guid>(
                name: "DocumentId",
                table: "DocumentAuditTrails",
                type: "uniqueidentifier",
                nullable: false,
                defaultValue: new Guid("00000000-0000-0000-0000-000000000000"),
                oldClrType: typeof(Guid),
                oldType: "uniqueidentifier",
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Categories",
                type: "nvarchar(max)",
                nullable: true,
                oldClrType: typeof(string),
                oldType: "nvarchar(450)",
                oldNullable: true);

            migrationBuilder.AddPrimaryKey(
                name: "PK_DocumentChunk",
                table: "DocumentChunk",
                column: "Id");

            migrationBuilder.AddForeignKey(
                name: "FK_DocumentChunk_DocumentVersions_DocumentVersionId",
                table: "DocumentChunk",
                column: "DocumentVersionId",
                principalTable: "DocumentVersions",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_DocumentIndexes_Documents_DocumentId",
                table: "DocumentIndexes",
                column: "DocumentId",
                principalTable: "Documents",
                principalColumn: "Id",
                onDelete: ReferentialAction.Cascade);
        }
    }
}
