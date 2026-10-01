using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations
{
    /// <inheritdoc />
    public partial class Remove_PageAction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
                DELETE RC
                FROM RoleClaims RC
                INNER JOIN PageActions PA ON RC.PageActionId = PA.Id
                WHERE PA.Code IN ('All_Manage_Indexing', 'Assigned_Manage_Indexing', 'Assigned_Download_Document');

                DELETE FROM PageActions
                WHERE Code IN ('All_Manage_Indexing', 'Assigned_Manage_Indexing', 'Assigned_Download_Document');
                    ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
