using Microsoft.EntityFrameworkCore.Migrations;

#nullable disable

namespace DocumentManagement.Domain.Migrations
{
    /// <inheritdoc />
    public partial class Remove_PageName_From_PageAction : Migration
    {
        /// <inheritdoc />
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.Sql(@"
       UPDATE pa
    SET pa.Name = REPLACE(pa.Name, p.Name + '_', '') 
    FROM PageActions pa
    INNER JOIN Screens p ON pa.PageId = p.Id
    ");
        }

        /// <inheritdoc />
        protected override void Down(MigrationBuilder migrationBuilder)
        {

        }
    }
}
