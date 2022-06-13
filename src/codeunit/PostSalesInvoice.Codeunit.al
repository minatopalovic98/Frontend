codeunit 50255 "Post Sales Invoice"
{
    procedure PostInvoice(payload: Text) responseText: Text;
    var
        NAV: Codeunit "NAV Post";
        Header: Codeunit "Patch Header";
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        requestHeaders: HttpHeaders;

        JsonObject: JsonObject;
        Token: JsonToken;
        IdText: Text;
    begin
        content.Clear();
        contentHeaders.Clear();
        requestHeaders.Clear();

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

        request.SetRequestUri('http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/v2.0/companies(6db696fa-d6d5-ec11-9624-6045bd8fe131)/salesInvoices?$expand=salesInvoiceLines');

        request.Method := 'POST';

        if not client.Send(request, response) then
            Error('Http message could not be sent. Endpoint is not available.');

        if not response.IsSuccessStatusCode() then
            Error('Error Response code: %1', response.HttpStatusCode());

        // Read the response content as json text and return it as return value.
        response.Content().ReadAs(responseText);


        JsonObject.ReadFrom(responseText);
        JsonObject.Get('id', Token);
        IdText := Token.AsValue().AsText();

        Header.ModifyHeader(IdText);

        //poziva se codeunit koji izvršava knjiženje
        NAV.PostInvoiceNAV(IdText);
    end;
}
