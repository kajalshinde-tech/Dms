using System;
using System.ComponentModel.DataAnnotations.Schema;
using DocumentManagement.Data.Entities;

namespace DocumentManagement.Data;

public class DocumentUserPermission : BaseEntity
{
    public Guid Id { get; set; }
    public Guid DocumentId { get; set; }
    public Guid UserId { get; set; }
    public DateTime? StartDate { get; set; }
    public DateTime? EndDate { get; set; }
    public bool IsTimeBound { get; set; }
    public bool IsAllowDownload { get; set; }
    [ForeignKey("CreatedBy")]
    public User CreatedByUser { get; set; }
    [ForeignKey("DocumentId")]
    public Document Document { get; set; }
    [ForeignKey("UserId")]
    public User User { get; set; }
}
