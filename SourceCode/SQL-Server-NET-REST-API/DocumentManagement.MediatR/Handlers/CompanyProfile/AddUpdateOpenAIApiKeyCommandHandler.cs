using DocumentManagement.Common.UnitOfWork;
using DocumentManagement.Domain;
using DocumentManagement.Helper;
using DocumentManagement.MediatR.Commands;
using DocumentManagement.Repository;
using MediatR;
using Microsoft.EntityFrameworkCore;
using Mscc.GenerativeAI;
using OpenAI.Chat;
using System;
using System.Threading;
using System.Threading.Tasks;

namespace DocumentManagement.MediatR.Handlers;
public class AddUpdateOpenAIApiKeyCommandHandler(ICompanyProfileRepository companyProfileRepository, IUnitOfWork<DocumentContext> _uow) : IRequestHandler<AddUpdateOpenAIApiKeyCommand, ServiceResponse<bool>>
{
    public async Task<ServiceResponse<bool>> Handle(AddUpdateOpenAIApiKeyCommand request, CancellationToken cancellationToken)
    {
        var companyProfile = await companyProfileRepository
              .FindBy(c => c.Id == request.Id)
              .FirstOrDefaultAsync();


        if (request.Company == "openai" && !string.IsNullOrEmpty(request.OpenAIAPIKey) && !TestOpenAIAPIKey(request.OpenAIAPIKey))
        {
            return ServiceResponse<bool>.Return404("OPENAI API Key is not correct.");
        }
        if (request.Company == "gemini" && !string.IsNullOrEmpty(request.OpenAIAPIKey) && !await TestGeminiKey(request.OpenAIAPIKey))
        {
            return ServiceResponse<bool>.Return404("OPENAI API Key is not correct.");
        }
        if (companyProfile == null)
        {
            return ServiceResponse<bool>.Return404("No record found.");
        }
        if (request.Company == "openai")
        {
            companyProfile.OpenAIAPIKey = request.OpenAIAPIKey;
        }
        if (request.Company == "gemini")
        {
            companyProfile.GeminiAPIKey = request.OpenAIAPIKey;
        }
        companyProfileRepository.Update(companyProfile);
        if (await _uow.SaveAsync() <= -1)
        {
            return ServiceResponse<bool>.Return500();
        }
        return ServiceResponse<bool>.ReturnResultWith200(true);
    }

    private bool TestOpenAIAPIKey(string apiKey)
    {
        ChatClient client = new(model: "gpt-3.5-turbo", apiKey: apiKey);
        try
        {
            var result = client.CompleteChat("What's 2 + 2?");
            return true;
        }
        catch (Exception)
        {
            return false;
        }
    }

    private async Task<bool> TestGeminiKey(string apiKey)
    {
        var googleAI = new GoogleAI(apiKey: apiKey);
        var model = googleAI.GenerativeModel(model: Model.Gemini15Flash);
        try
        {
            using var cts = new CancellationTokenSource(TimeSpan.FromSeconds(60));
            // 🔹 Small document → single API call
            string prompt = $"\"What's 2 + 2?\"";
            var response = await model.GenerateContent(prompt, cancellationToken: cts.Token);
            return true;
        }
        catch (Exception ex)
        {
            return false;
        }
    }
}
