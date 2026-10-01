using DocumentManagement.Data.Dto;
using MediatR;
using System;

namespace DocumentManagement.MediatR.Queries
{
    public class GetOperationQuery : IRequest<OperationDto>
    {
        public Guid Id { get; set; }
    }
}
