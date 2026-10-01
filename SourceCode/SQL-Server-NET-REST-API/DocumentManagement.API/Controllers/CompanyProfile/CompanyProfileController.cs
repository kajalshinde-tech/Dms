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
public class CompanyProfileController(IMediator _mediator) : BaseController
{
    /// <summary>
    /// Gets the company profile.
    /// </summary>
    /// <param name="id">The identifier.</param>
    /// <returns></returns>
    [HttpGet(Name = "GetCompanyProfile")]
    [Produces("application/json", "application/xml", Type = typeof(List<CompanyProfileDto>))]
    [AllowAnonymous]
    public async Task<IActionResult> GetCompanyProfile()
    {
        var query = new GetCompanyProfileQuery { };
        var result = await _mediator.Send(query);
        return Ok(result.Data);
    }

    /// <summary>
    /// Updates the company profile.
    /// </summary>
    /// <param name="id">The identifier.</param>
    /// <param name="updateCompanyProfileCommand">The update company profile command.</param>
    /// <returns></returns>
    [HttpPost("{id?}")]
    [Produces("application/json", "application/xml", Type = typeof(CompanyProfileDto))]
    [ClaimCheck("manage_company_settings")]
    public async Task<IActionResult> UpdateCompanyProfile(Guid? id, [FromForm] UpdateCompanyProfileCommand updateCompanyProfileCommand)
    {
        if (id.HasValue && id.Value != Guid.Empty)
        {
            updateCompanyProfileCommand.Id = id.Value;
        }
        var result = await _mediator.Send(updateCompanyProfileCommand);
        return GenerateResponse(result);
    }

    [HttpPost("{id}/allow-signature")]
    [Produces("application/json", "application/xml", Type = typeof(bool))]
    [ClaimCheck("general_settings")]
    public async Task<IActionResult> AddOrUpdateAddSignature(Guid id, AddUpdateSignatureIntoPdfFlagCommand addUpdateSignatureIntoPdfFlagCommand)
    {
        addUpdateSignatureIntoPdfFlagCommand.Id = id;
        var result = await _mediator.Send(addUpdateSignatureIntoPdfFlagCommand);
        return GenerateResponse(result);
    }

    [HttpPost("{id}/openai-api-key")]
    [Produces("application/json", "application/xml", Type = typeof(bool))]
    [ClaimCheck("general_settings")]
    public async Task<IActionResult> AddOrUpdateOpenAIAPIKey(Guid id, AddUpdateOpenAIApiKeyCommand addUpdateOpenAIApiKeyCommand)
    {
        addUpdateOpenAIApiKeyCommand.Id = id;
        var result = await _mediator.Send(addUpdateOpenAIApiKeyCommand);
        return GenerateResponse(result);
    }
    [HttpPost("activate_license")]
    [Produces("application/json", "application/xml", Type = typeof(bool))]
    [AllowAnonymous]
    public async Task<IActionResult> AddOrUpdateLicenseKey(UpdateActivatedLicenseCommand updateActivatedLicenseCommand)
    {
        var result = await _mediator.Send(updateActivatedLicenseCommand);
        return Ok(result);
    }
}
