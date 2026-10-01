using DocumentManagement.Common.UnitOfWork;
using DocumentManagement.Data.Dto;
using DocumentManagement.Domain;
using DocumentManagement.Helper;
using DocumentManagement.MediatR.Commands;
using DocumentManagement.Repository;
using MediatR;
using Microsoft.AspNetCore.SignalR;
using Microsoft.EntityFrameworkCore;
using Mscc.GenerativeAI;
using OpenAI.Chat;
using System;
using System.ClientModel;
using System.Linq;
using System.Net.Http;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace DocumentManagement.MediatR.Handlers;
public class GetUserOpenaiMsgByIdQueryHandler(
    IUserOpenaiMsgRepository userOpenaiMsgRepository,
    IHttpClientFactory httpClientFactory,
    Helper.PathHelper pathHelper,
    UserInfoToken userInfoToken,
    IUnitOfWork<DocumentContext> _uow,
     IConnectionMappingRepository connectionMappingRepository,
     ICompanyProfileRepository companyProfileRepository,
    IHubContext<UserHub, IHubClient> hubContext) : IRequestHandler<GetUserOpenaiMsgByIdQuery, ServiceResponse<bool>>
{
    public async Task<ServiceResponse<bool>> Handle(GetUserOpenaiMsgByIdQuery request, CancellationToken cancellationToken)
    {

        var userOpenaiMsg = await userOpenaiMsgRepository.All.Where(c => c.Id == request.Id).FirstOrDefaultAsync();
        if (userOpenaiMsg == null)
        {
            return ServiceResponse<bool>.Return404("Open ai message not found");
        }

        var companyProfile = await companyProfileRepository.All.FirstOrDefaultAsync();
        if (companyProfile == null)
        {
            return ServiceResponse<bool>.ReturnFailed(409, "Company profile is not found.");
        }
        if (userOpenaiMsg.SelectedModel.ToLower().Contains("gpt-") && string.IsNullOrEmpty(companyProfile.OpenAIAPIKey))
        {
            return ServiceResponse<bool>.ReturnFailed(404, "Configure OpenAI key into General Settings.");
        }
        if (userOpenaiMsg.SelectedModel.ToLower().Contains("gemini-") && string.IsNullOrEmpty(companyProfile.GeminiAPIKey))
        {
            return ServiceResponse<bool>.ReturnFailed(404, "Configure Gemini APIKey into General Settings.");
        }
        var prompt = userOpenaiMsg.PromptInput;

        if (!string.IsNullOrWhiteSpace(userOpenaiMsg.Language))
        {
            prompt = $"{prompt} Language is {userOpenaiMsg.Language}.";
        }
        if (userOpenaiMsg.Creativity > 0)
        {
            prompt = $"{prompt} Creativity is {userOpenaiMsg.Creativity} between 0 and 1.";
        }

        if (userOpenaiMsg.MaximumLength > 0)
        {
            prompt = $"{prompt} Maximum {userOpenaiMsg.MaximumLength} words.";
        }
        if (!string.IsNullOrWhiteSpace(userOpenaiMsg.ToneOfVoice))
        {
            prompt = $"{prompt} Tone of voice must be {userOpenaiMsg.ToneOfVoice}.";
        }
        string response = string.Empty;
        if (userOpenaiMsg.SelectedModel.ToLower().Contains("gpt-"))
        {
            response = await streamOpenAIResponse(userOpenaiMsg.Id, prompt, userOpenaiMsg.SelectedModel, companyProfile.OpenAIAPIKey);
        }
        else if (userOpenaiMsg.SelectedModel.ToLower().Contains("gemini-"))
        {
            response = await streamGeminiResponse(userOpenaiMsg.Id, prompt, userOpenaiMsg.SelectedModel, companyProfile.GeminiAPIKey, cancellationToken);
        }

        if (string.IsNullOrEmpty(response))
        {
            return ServiceResponse<bool>.Return404("Open ai message not found");
        }
        userOpenaiMsg.AiResponse = response;
        userOpenaiMsgRepository.Update(userOpenaiMsg);
        if (await _uow.SaveAsync() <= 0)
        {
            return ServiceResponse<bool>.ReturnFailed(500, "Error While Added UserOpenaimsg");
        }

        return ServiceResponse<bool>.ReturnResultWith200(true);
    }

    public async Task<string> streamGeminiResponse(Guid msgId, string message, string geminimodel, string geminiApiKey, CancellationToken cancellationToken)
    {
        try
        {
            var googleAI = new GoogleAI(apiKey: geminiApiKey);
            var model = googleAI.GenerativeModel(model: geminimodel);
            var fullResponseText = new StringBuilder();

            try
            {
                await foreach (var chunk in model.GenerateContentStream(message))
                {
                    if (!string.IsNullOrEmpty(chunk.Text))
                    {
                        string htmlChunk = System.Net.WebUtility.HtmlEncode(chunk.Text).Replace("\r\n", "<br/>")
                         .Replace("\r", "<br/>")
                         .Replace("\n", "<br/>")
                         .Replace("\n\n", "<br/>");
                        fullResponseText.Append(htmlChunk);
                        var userInfo = connectionMappingRepository.GetUserInfoById(userInfoToken.Id);
                        if (userInfo?.ConnectionId != null)
                        {
                            await hubContext.Clients.Client(userInfo.ConnectionId).SendAiPromptResponse(msgId, htmlChunk);
                            await Task.Delay(50);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                // Log or handle the exception appropriately.
                Console.WriteLine($"Error during streaming: {ex.Message}");
                return string.Empty;
            }
            var newUserInfo = connectionMappingRepository.GetUserInfoById(userInfoToken.Id);
            if (newUserInfo?.ConnectionId != null)
            {
                await hubContext.Clients.Client(newUserInfo?.ConnectionId).SendAiPromptResponse(msgId, "[[DONE]]");
            }

            return fullResponseText.ToString();

        }
        catch (Exception ex)
        {
            throw ex;
        }

    }

    public async Task<string> streamOpenAIResponse(Guid msgId, string message, string model, string openAPIKey)
    {
        //var userInfo = connectionMappingRepository.GetUserInfoById(userInfoToken.Id);

        //for (var i = 0; i < 100; i++)
        //{
        //    await hubContext.Clients.Client(userInfo.ConnectionId).SendAiPromptResponse(Guid.NewGuid(), "lafsdsdfsdfssdf sfdsdfsdsdf sdfsdsdfsdf sadfsfdsdf");

        //    await Task.Delay(500);
        //}
        //return "ssdfsfdfssdfsdfsd"; // Placeholder for the final response

        var apiKey = openAPIKey;

        string finalResponse = string.Empty;

        ChatClient client = new(model: model, apiKey: apiKey);

        AsyncCollectionResult<StreamingChatCompletionUpdate> completionUpdates = client.CompleteChatStreamingAsync(message);


        await foreach (StreamingChatCompletionUpdate completionUpdate in completionUpdates)
        {
            // string content = completionUpdate?.Choices?.FirstOrDefault()?.Delta?.Content;

            if (completionUpdate.ContentUpdate.Count > 0)
            {
                var content = completionUpdate.ContentUpdate[0].Text;
                content = content.Replace("\r\n", "<br/>")
                          .Replace("\r", "<br/>")
                          .Replace("\n", "<br/>");

                finalResponse += content;
                if (string.IsNullOrEmpty(content))
                {
                    continue;
                }
                var userInfonew = connectionMappingRepository.GetUserInfoById(userInfoToken.Id);
                if (userInfonew != null)
                {
                    var connectionId = userInfonew.ConnectionId;
                    if (connectionId != null)
                    {
                        await hubContext.Clients.Client(connectionId).SendAiPromptResponse(msgId, content);
                        await Task.Delay(50); // Delay to simulate streaming
                    }
                }

            }
        }
        var userInfo = connectionMappingRepository.GetUserInfoById(userInfoToken.Id);
        if (userInfo != null)
        {
            var connectionId = userInfo.ConnectionId;
            if (connectionId != null)
            {
                await hubContext.Clients.Client(connectionId).SendAiPromptResponse(msgId, "[[DONE]]");
            }
        }
        return finalResponse;
    }
}
