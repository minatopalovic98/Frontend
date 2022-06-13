codeunit 50250 "Patch Header"
{
    procedure ModifyHeader(SalesHeaderId: Text) responseText: Text;
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        requestHeaders: HttpHeaders;
        JsonObject: JsonObject;
        payload: Text;
    begin
        content.Clear();
        contentHeaders.Clear();
        requestHeaders.Clear();

        JsonObject.Add('paymentMethodCode', 'CARD');
        JsonObject.WriteTo(payload);

        // Add the payload to the content
        content.WriteFrom(payload);

        // Retrieve the contentHeaders associated with the content
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        contentHeaders.Add('Content-Type', 'application/json');

        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in 
        // the content associated with the request message (!!!)
        request.Content := content;
        request.GetHeaders(requestHeaders);
        requestHeaders.Clear();

        requestHeaders.Add('Authorization', 'Basic U1RVREVOVDpUb3JlazU1NyE=');
        requestHeaders.Add('If-Match', '*');

        request.SetRequestUri('http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/mina/webShop/v1.0/headers(' + SalesHeaderId + ')?company=Mina''s web shop');

        request.Method := 'PATCH';

        if not client.Send(request, response) then
            Error('Http message could not be sent. Endpoint is not available.');

        if not response.IsSuccessStatusCode() then
            Error('Error Response code: %1', response.HttpStatusCode());

        // Read the response content as json text and return it as return value.
        response.Content().ReadAs(responseText);
    end;
}
