using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace DocumentManagement.Data.Entities;

public class DocumentIndex
{
    public Guid Id { get; set; }
    public Guid DocumentId { get; set; }
    public DateTime CreatedDate { get; set; }
    public Guid DocumentVersionId { get; set; }
    [ForeignKey("DocumentVersionId")]
    public DocumentVersion DocumentVersion { get; set; }
}
