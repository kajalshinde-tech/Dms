using DocumentManagement.Data.Dto;
using DocumentManagement.Helper;
using MediatR;
using System;

namespace DocumentManagement.MediatR.Queries
{
    public class GetScreenQuery : IRequest<ServiceResponse<ScreenDto>>
    {
        public Guid Id { get; set; }
    }
}
