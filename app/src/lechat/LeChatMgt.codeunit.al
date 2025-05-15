codeunit 50100 "RAA LeChat Mgt."
{

    procedure GenerateAssignments(InputText: Text): Boolean
    var
        APIResponse: Text;
    begin
        // request LeChat API
        APIResponse := RequestLeChatAPI(InputText);

        ExtractChatAnswer(APIResponse);

        //Parse response as JSON
        CreateAssignmentsFromResponse(APIResponse);
        // Create Assignments based on json response
    end;

    local procedure RequestLeChatAPI(InputText: Text): Text
    var
        Client: HttpClient;
        RequestMessage: HttpRequestMessage;
        RequestContent: HttpContent;
        ContentObj: JsonObject;
        MessageArray: JsonArray;
        MessageObj: JsonObject;
        xml: XmlDocument;
        ContentString: Text;
        ContentHeaders: HttpHeaders;
        RequestHeaders: HttpHeaders;
        ResponseMessage: HttpResponseMessage;
        ResponseString: Text;
    begin
        ContentObj.Add('agent_id', 'ag:99a6349f:20250514:assignment-agent:6b894b38');

        MessageObj.Add('role', 'user');
        MessageObj.Add('content', InputText);

        MessageArray.Add(MessageObj);
        ContentObj.Add('messages', MessageArray);

        ContentObj.WriteTo(ContentString);
        RequestContent.WriteFrom(ContentString);
        RequestContent.GetHeaders(ContentHeaders);
        ContentHeaders.Remove('Content-Type');
        ContentHeaders.Add('Content-Type', 'application/json');

        RequestMessage.Content(RequestContent);
        RequestMessage.GetHeaders(RequestHeaders);
        RequestHeaders.Add('Authorization', 'Bearer 6dswgupHlHo5iR31AzAzpcgemEt5mL0G');

        RequestMessage.Method('POST');
        RequestMessage.SetRequestUri('https://api.mistral.ai/v1/agents/completions');

        if not Client.Send(RequestMessage, ResponseMessage) then
            Error('Error sending request to LeChat API');

        if not ResponseMessage.IsSuccessStatusCode() then
            Error('Error in response from LeChat API: %1', ResponseMessage.HttpStatusCode());

        ResponseMessage.Content.ReadAs(ResponseString);
        exit(ResponseString);
    end;

    local procedure ExtractChatAnswer(var APIResponse: Text)
    var
        JObject: JsonObject;
        ContentToken: JsonToken;
    begin
        JObject.ReadFrom(APIResponse);
        if not JObject.SelectToken('choices[0].message.content', ContentToken) then
            Error('Error parsing JSON response from LeChat API');

        APIResponse := ContentToken.AsValue().AsText()
    end;

    local procedure CreateAssignmentsFromResponse(APIResponse: Text)
    var
        JObject: JsonObject;
        AssignmentArray: JsonArray;
        AssignmentObj: JsonObject;
        AssignmentToken: JsonToken;
        AssignmentArrayToken: JsonToken;
        TaskToken: JsonToken;
        DetailsToken: JsonToken;
    begin
        JObject.ReadFrom(APIResponse);
        JObject.SelectToken('assignments', AssignmentArrayToken);
        AssignmentArray := AssignmentArrayToken.AsArray();

        foreach AssignmentToken in AssignmentArray do begin
            AssignmentToken.SelectToken('task', TaskToken);
            AssignmentToken.SelectToken('details', DetailsToken);

            InsertAssignment(TaskToken.AsValue().AsText(), DetailsToken.AsValue().AsText());
        end;
    end;

    local procedure InsertAssignment(Title: Text; Description: Text)
    var
        Assignment: Record "RAA Assignment";
    begin
        Assignment.Init();
        Assignment.Validate(Title, Title);
        Assignment.Validate(Description, Description);
        Assignment.Validate(Status, Assignment.Status::Incomplete);
        Assignment.Insert(true);
    end;
}
