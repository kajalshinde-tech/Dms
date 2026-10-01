using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations
{
    /// <inheritdoc />
    public partial class Entry_Into_PageAction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            // Step 1: Insert PageAction
            migrationBuilder.Sql(@"
            INSERT INTO PageActions (Id, Name, [Order], PageId, Code)
            SELECT 
                so.Id, -- Use ScreenOperation.Id as PageAction.Id
                s.Name + '_' + o.Name AS Name,
                ROW_NUMBER() OVER(PARTITION BY so.ScreenId ORDER BY o.Name) AS [Order],
                so.ScreenId AS PageId,
                 REPLACE(o.Name, ' ', '_') AS Code
            FROM ScreenOperations so
            INNER JOIN Screens s ON so.ScreenId = s.Id
            INNER JOIN Operations o ON so.OperationId = o.Id
        ");


            // Step 2: Update UserClaim to point to new PageAction.Id
            migrationBuilder.Sql(@"
        UPDATE uc
        SET PageActionId = so.Id
        FROM UserClaims uc
        INNER JOIN ScreenOperations so 
            ON uc.OperationId = so.OperationId AND uc.ScreenId = so.ScreenId
    ");

            // Step 3: Update RoleClaim to point to new PageAction.Id
            migrationBuilder.Sql(@"
        UPDATE rc
        SET PageActionId = so.Id
        FROM RoleClaims rc
        INNER JOIN ScreenOperations so 
            ON rc.OperationId = so.OperationId AND rc.ScreenId = so.ScreenId
    ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
