using System;

namespace DocumentManagement.Data.Entities;

public class DocumentToken
{
    public Guid Id { get; set; }
    public Guid DocumentId { get; set; }
    public Guid Token { get; set; }
    public DateTime CreatedDate { get; set; }
}
