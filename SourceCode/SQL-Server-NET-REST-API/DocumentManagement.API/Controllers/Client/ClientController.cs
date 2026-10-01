using AuthChecker;
using DocumentManagement.Data.Dto;
using DocumentManagement.MediatR.Commands;
using DocumentManagement.MediatR.Queries;
using MediatR;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace DocumentManagement.API.Controllers;

[Route("api/[controller]")]
[ApiController]
[Authorize]
public class ClientController(IMediator _mediator) : BaseController
{
    /// <summary>
    /// Creates the Client.
    /// </summary>
    /// <param name="command">The command.</param>
    /// <returns></returns>
    [HttpPost]
    [ClaimCheck("add_clients")]
    public async Task<IActionResult> AddClient(AddClientCommand command)
    {
        var result = await _mediator.Send(command);
        return GenerateResponse(result);
    }

    /// <summary>
    /// Updates the Client.
    /// </summary>
    /// <param name="id">The identifier.</param>
    /// <param name="updateClientCommand">The update storage setting command.</param>
    /// <returns></returns>
    [HttpPut("{id}")]
    [Produces("application/json", "application/xml", Type = typeof(WorkflowDto))]
    [ClaimCheck("edit_clients")]
    public async Task<IActionResult> UpdateClient(Guid id, UpdateClientCommand command)
    {
        var result = await _mediator.Send(command);
        return GenerateResponse(result);
    }

    // <summary>
    /// Deletes the Client.
    /// </summary>
    /// <param name="id">The identifier.</param>
    /// <returns></returns>
    [HttpDelete("{id}")]
    [ClaimCheck("delete_clients")]
    public async Task<IActionResult> DeleteClient(Guid id)
    {
        var query = new DeleteClientCommand { Id = id };
        var result = await _mediator.Send(query);
        return GenerateResponse(result);
    }

    /// <summary>
    /// Gets the Client.
    /// </summary>
    /// <param name="id">The identifier.</param>
    /// <returns></returns>
    [HttpGet("{id}")]
    public async Task<IActionResult> GetClient(Guid id)
    {
        var query = new GetClientQuery { Id = id };
        var result = await _mediator.Send(query);
        return Ok(result.Data);
    }

    /// <summary>
    /// Get All Clients.
    /// </summary>
    /// <returns></returns>
    [HttpGet]
    [Produces("application/json", "application/xml", Type = typeof(List<ClientDto>))]
    public async Task<IActionResult> GetClients()
    {
        var getAllClientQuery = new GetAllClientQuery { };
        var result = await _mediator.Send(getAllClientQuery);
        return Ok(result.Data);
    }
}
