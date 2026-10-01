using DocumentManagement.Data.Dto;
using MediatR;
using System;

namespace DocumentManagement.MediatR.Commands
{
    public class UpdateScreenCommand : IRequest<ScreenDto>
    {
        public Guid Id { get; set; }
        public string Name { get; set; }
        public int OrderNo { get; set; } = 0;
    }
}
