codeunit 50256 "NAV Post"
{
    procedure PostInvoiceNAV(id: Text) responseText: Text;
    var
        client: HttpClient;
        request: HttpRequestMessage;
        response: HttpResponseMessage;
        contentHeaders: HttpHeaders;
        content: HttpContent;
        requestHeaders: HttpHeaders;
    begin
        content.Clear();
        contentHeaders.Clear();
        requestHeaders.Clear();

        // Add the payload to the content
        //content.WriteFrom(payload);

        // Retrieve the contentHeaders associated with the content
        content.GetHeaders(contentHeaders);
        contentHeaders.Clear();
        //contentHeaders.Add('Content-Type', 'application/json');

        // Assigning content to request.Content will actually create a copy of the content and assign it.
        // After this line, modifying the content variable or its associated headers will not reflect in 
        // the content associated with the request message (!!!)
        request.Content := content;
        request.GetHeaders(requestHeaders);
        requestHeaders.Clear();

        requestHeaders.Add('Authorization', 'Basic U1RVREVOVDpUb3JlazU1NyE=');

        request.SetRequestUri('http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/v2.0/companies(6db696fa-d6d5-ec11-9624-6045bd8fe131)/salesInvoices(' + id + ')/Microsoft.NAV.post');

        request.Method := 'POST';

        if not client.Send(request, response) then
            Error('Http message could not be sent. Endpoint is not available.');

        if not response.IsSuccessStatusCode() then
            Error('Error Response code: %1', response.HttpStatusCode());

        // Read the response content as json text and return it as return value.
        response.Content().ReadAs(responseText);


        Message('Your order has been successful and your items are on their way. Thank you for shopping with us. 🥰');
    end;
}
