using System;
using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations;

/// <inheritdoc />
public partial class Version_V7 : Migration
{
    /// <inheritdoc />
    protected override void Up(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "WorkFlowStepRoles");

        migrationBuilder.DropTable(
            name: "WorkflowStepUsers");

        migrationBuilder.DropIndex(
            name: "IX_DocumentVersions_DocumentId",
            table: "DocumentVersions");

        migrationBuilder.DropColumn(
            name: "IsSignatureRequired",
            table: "WorkflowSteps");

        migrationBuilder.AddColumn<string>(
            name: "Color",
            table: "WorkflowTransitions",
            type: "nvarchar(max)",
            nullable: true);

        migrationBuilder.AddColumn<bool>(
            name: "IsSignatureRequired",
            table: "WorkflowTransitions",
            type: "bit",
            nullable: false,
            defaultValue: false);

        migrationBuilder.AddColumn<int>(
            name: "OrderNo",
            table: "WorkflowTransitions",
            type: "int",
            nullable: false,
            defaultValue: 0);

        migrationBuilder.AddColumn<bool>(
            name: "IsSuperAdmin",
            table: "Users",
            type: "bit",
            nullable: false,
            defaultValue: false);

        migrationBuilder.AlterColumn<string>(
            name: "Url",
            table: "DocumentVersions",
            type: "nvarchar(450)",
            nullable: true,
            oldClrType: typeof(string),
            oldType: "nvarchar(max)",
            oldNullable: true);

        migrationBuilder.AddColumn<bool>(
            name: "IsShared",
            table: "Documents",
            type: "bit",
            nullable: false,
            defaultValue: false);

        migrationBuilder.AddColumn<bool>(
            name: "IsUnreadComment",
            table: "DocumentComments",
            type: "bit",
            nullable: false,
            defaultValue: false);

        migrationBuilder.AddColumn<string>(
            name: "LogoIconUrl",
            table: "CompanyProfiles",
            type: "nvarchar(max)",
            nullable: true);

        migrationBuilder.AddColumn<string>(
            name: "OpenAIAPIKey",
            table: "CompanyProfiles",
            type: "nvarchar(max)",
            nullable: true);

        migrationBuilder.CreateTable(
            name: "AIPromptTemplates",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                Name = table.Column<string>(type: "nvarchar(max)", nullable: true),
                Description = table.Column<string>(type: "nvarchar(max)", nullable: true),
                PromptInput = table.Column<string>(type: "nvarchar(max)", nullable: true),
                IsActive = table.Column<bool>(type: "bit", nullable: false),
                ModifiedDate = table.Column<DateTime>(type: "datetime2", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_AIPromptTemplates", x => x.Id);
            });

        migrationBuilder.CreateTable(
            name: "UserOpenaiMsgs",
            columns: table => new
            {
                Id = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                Title = table.Column<string>(type: "nvarchar(max)", nullable: true),
                PromptInput = table.Column<string>(type: "nvarchar(max)", nullable: true),
                Language = table.Column<string>(type: "nvarchar(max)", nullable: true),
                MaximumLength = table.Column<int>(type: "int", nullable: false),
                Creativity = table.Column<decimal>(type: "decimal(18,6)", precision: 18, scale: 6, nullable: false),
                ToneOfVoice = table.Column<string>(type: "nvarchar(max)", nullable: true),
                SelectedModel = table.Column<string>(type: "nvarchar(max)", nullable: true),
                AiResponse = table.Column<string>(type: "nvarchar(max)", nullable: true),
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
                table.PrimaryKey("PK_UserOpenaiMsgs", x => x.Id);
                table.ForeignKey(
                    name: "FK_UserOpenaiMsgs_Users_CreatedBy",
                    column: x => x.CreatedBy,
                    principalTable: "Users",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "WorkflowTransitionRoles",
            columns: table => new
            {
                WorkflowTransitionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_WorkflowTransitionRoles", x => new { x.WorkflowTransitionId, x.RoleId });
                table.ForeignKey(
                    name: "FK_WorkflowTransitionRoles_Roles_RoleId",
                    column: x => x.RoleId,
                    principalTable: "Roles",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_WorkflowTransitionRoles_WorkflowTransitions_WorkflowTransitionId",
                    column: x => x.WorkflowTransitionId,
                    principalTable: "WorkflowTransitions",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "WorkflowTransitionUsers",
            columns: table => new
            {
                WorkflowTransitionId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_WorkflowTransitionUsers", x => new { x.WorkflowTransitionId, x.UserId });
                table.ForeignKey(
                    name: "FK_WorkflowTransitionUsers_Users_UserId",
                    column: x => x.UserId,
                    principalTable: "Users",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_WorkflowTransitionUsers_WorkflowTransitions_WorkflowTransitionId",
                    column: x => x.WorkflowTransitionId,
                    principalTable: "WorkflowTransitions",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateIndex(
            name: "IX_DocumentVersions_DocumentId_Url_CreatedBy",
            table: "DocumentVersions",
            columns: new[] { "DocumentId", "Url", "CreatedBy" });

        migrationBuilder.CreateIndex(
            name: "IX_UserOpenaiMsgs_CreatedBy",
            table: "UserOpenaiMsgs",
            column: "CreatedBy");

        migrationBuilder.CreateIndex(
            name: "IX_WorkflowTransitionRoles_RoleId",
            table: "WorkflowTransitionRoles",
            column: "RoleId");

        migrationBuilder.CreateIndex(
            name: "IX_WorkflowTransitionUsers_UserId",
            table: "WorkflowTransitionUsers",
            column: "UserId");
    }

    /// <inheritdoc />
    protected override void Down(MigrationBuilder migrationBuilder)
    {
        migrationBuilder.DropTable(
            name: "AIPromptTemplates");

        migrationBuilder.DropTable(
            name: "UserOpenaiMsgs");

        migrationBuilder.DropTable(
            name: "WorkflowTransitionRoles");

        migrationBuilder.DropTable(
            name: "WorkflowTransitionUsers");

        migrationBuilder.DropIndex(
            name: "IX_DocumentVersions_DocumentId_Url_CreatedBy",
            table: "DocumentVersions");

        migrationBuilder.DropColumn(
            name: "Color",
            table: "WorkflowTransitions");

        migrationBuilder.DropColumn(
            name: "IsSignatureRequired",
            table: "WorkflowTransitions");

        migrationBuilder.DropColumn(
            name: "OrderNo",
            table: "WorkflowTransitions");

        migrationBuilder.DropColumn(
            name: "IsSuperAdmin",
            table: "Users");

        migrationBuilder.DropColumn(
            name: "IsShared",
            table: "Documents");

        migrationBuilder.DropColumn(
            name: "IsUnreadComment",
            table: "DocumentComments");

        migrationBuilder.DropColumn(
            name: "LogoIconUrl",
            table: "CompanyProfiles");

        migrationBuilder.DropColumn(
            name: "OpenAIAPIKey",
            table: "CompanyProfiles");

        migrationBuilder.AddColumn<bool>(
            name: "IsSignatureRequired",
            table: "WorkflowSteps",
            type: "bit",
            nullable: false,
            defaultValue: false);

        migrationBuilder.AlterColumn<string>(
            name: "Url",
            table: "DocumentVersions",
            type: "nvarchar(max)",
            nullable: true,
            oldClrType: typeof(string),
            oldType: "nvarchar(450)",
            oldNullable: true);

        migrationBuilder.CreateTable(
            name: "WorkFlowStepRoles",
            columns: table => new
            {
                WorkflowStepId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                RoleId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_WorkFlowStepRoles", x => new { x.WorkflowStepId, x.RoleId });
                table.ForeignKey(
                    name: "FK_WorkFlowStepRoles_Roles_RoleId",
                    column: x => x.RoleId,
                    principalTable: "Roles",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_WorkFlowStepRoles_WorkflowSteps_WorkflowStepId",
                    column: x => x.WorkflowStepId,
                    principalTable: "WorkflowSteps",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateTable(
            name: "WorkflowStepUsers",
            columns: table => new
            {
                WorkflowStepId = table.Column<Guid>(type: "uniqueidentifier", nullable: false),
                UserId = table.Column<Guid>(type: "uniqueidentifier", nullable: false)
            },
            constraints: table =>
            {
                table.PrimaryKey("PK_WorkflowStepUsers", x => new { x.WorkflowStepId, x.UserId });
                table.ForeignKey(
                    name: "FK_WorkflowStepUsers_Users_UserId",
                    column: x => x.UserId,
                    principalTable: "Users",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
                table.ForeignKey(
                    name: "FK_WorkflowStepUsers_WorkflowSteps_WorkflowStepId",
                    column: x => x.WorkflowStepId,
                    principalTable: "WorkflowSteps",
                    principalColumn: "Id",
                    onDelete: ReferentialAction.Cascade);
            });

        migrationBuilder.CreateIndex(
            name: "IX_DocumentVersions_DocumentId",
            table: "DocumentVersions",
            column: "DocumentId");

        migrationBuilder.CreateIndex(
            name: "IX_WorkFlowStepRoles_RoleId",
            table: "WorkFlowStepRoles",
            column: "RoleId");

        migrationBuilder.CreateIndex(
            name: "IX_WorkflowStepUsers_UserId",
            table: "WorkflowStepUsers",
            column: "UserId");
    }
}
