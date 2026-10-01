using System;
using System.ComponentModel.DataAnnotations.Schema;

namespace DocumentManagement.Data;

public abstract class BaseEntity
{
    private DateTime _createdDate;
    public DateTime CreatedDate
    {
        get => _createdDate;
        set => _createdDate = value;
    }
    public Guid CreatedBy { get; set; }

    private DateTime _modifiedDate;
    public DateTime ModifiedDate
    {
        get => _modifiedDate;
        set => _modifiedDate = value;
    }
    public Guid ModifiedBy { get; set; }
    private DateTime? _deletedDate;
    public DateTime? DeletedDate
    {
        get => _deletedDate;
        set => _deletedDate = value;
    }
    public Guid? DeletedBy { get; set; }
    [NotMapped]
    public ObjectState ObjectState { get; set; }
    public Boolean IsDeleted { get; set; } = false;
}
