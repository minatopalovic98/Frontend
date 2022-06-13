codeunit 50251 "Web Shop Loader"
{
    TableNo = Item;

    trigger OnRun()
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ValueResponseJsonToken: JsonToken;

    begin
        GetItemsJson(ValueResponseJsonToken);
        ParseResponse(Rec, ValueResponseJsonToken);
        GetItemsAttributes(ItemAttributeValueMapping);
    end;

    local procedure GetItemsJson(var JsonValueToken: JsonToken)
    var
        WebServiceSetup: Record "Web Service Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        OutputString: Text;
        JsonObjectDocument: JsonObject;
        WebShopItemsEndpointTok: Text;
    begin
        WebServiceSetup.Get();
        AddDefaultHeaders(HttpClient, WebServiceSetup.UserName, WebServiceSetup.Password);
        WebShopItemsEndpointTok := WebServiceSetup."Base Url" + 'items?company=Mina''s web shop&$filter=itemCategoryCode eq ''WARDROBE''';

        if not HttpClient.Get(WebShopItemsEndpointTok, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', WebShopItemsEndpointTok);

        if not (HttpResponseMessage.IsSuccessStatusCode()) then
            Error('Web service returned error %1.', HttpResponseMessage.HttpStatusCode());

        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(OutputString);
        JsonObjectDocument.ReadFrom(OutputString);
        JsonObjectDocument.Get('value', JsonValueToken);
    end;

    local procedure GetAttributeJson(var JsonValueToken: JsonToken)
    var
        WebServiceSetup: Record "Web Service Setup";
        HttpClient: HttpClient;
        HttpResponseMessage: HttpResponseMessage;
        HttpContent: HttpContent;
        OutputString: Text;
        JsonObjectDocument: JsonObject;
        WebShopItemsEndpointTok: Text;
    //HttpContent1: HttpContent;
    begin
        WebServiceSetup.Get();
        AddDefaultHeaders(HttpClient, WebServiceSetup.UserName, WebServiceSetup.Password);
        WebShopItemsEndpointTok := 'http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/mina/wd/v1.0/itemAttributesWD?company=Mina''s web shop';

        if not HttpClient.Get(WebShopItemsEndpointTok, HttpResponseMessage) then
            Error('The url %1 cannot be accessed.', WebShopItemsEndpointTok);


        //JSONObectBody.WriteTo(JSONObectAsText);
        //HttpContent1.WriteFrom(JSONObectAsText);


        if not (HttpResponseMessage.HttpStatusCode() = 200) then
            Error('Web service returned error %1.', HttpResponseMessage.HttpStatusCode());

        HttpContent := HttpResponseMessage.Content();
        HttpContent.ReadAs(OutputString);
        JsonObjectDocument.ReadFrom(OutputString);
        JsonObjectDocument.Get('value', JsonValueToken);
    end;

    local procedure AddDefaultHeaders(var HttpClient: HttpClient; UserName: Text; Password: Text)
    var
        Base64Convert: Codeunit "Base64 Convert";
        HttpHeaders: HttpHeaders;
        UserPwdTok: Label '%1:%2', Comment = '%1 = Username, %2 = Password.';
    begin
        HttpHeaders := HttpClient.DefaultRequestHeaders();
        HttpHeaders.Add('Authorization', 'Basic ' + Base64Convert.ToBase64(StrSubstNo(UserPwdTok, UserName, Password)));
    end;

    local procedure ParseResponse(var Item: Record Item; var ValueResponseJsonToken: JsonToken)
    var
        JsonArrayErr: Label 'JSON parse error: JSON is not an array!';
        ItemsArray: JsonArray;
        ItemJsonToken: JsonToken;
        ItemJsonObject: JsonObject;
    begin
        if ValueResponseJsonToken.IsArray() then
            ItemsArray := ValueResponseJsonToken.AsArray()
        else
            Error(JsonArrayErr);

        foreach ItemJsonToken in ItemsArray do begin
            ItemJsonObject := ItemJsonToken.AsObject();
            Item.Init();

            Item."No." := CopyStr(GetFieldValue(ItemJsonObject, 'number').AsCode(), 1, MaxStrLen(Item."No."));

            if not Item.Insert(true) then
                Item.Modify(true);
            Item.Description := CopyStr(GetFieldValue(ItemJsonObject, 'dispalyName').AsText(), 1, MaxStrLen(Item.Description));
            Item."Unit Price" := GetFieldValue(ItemJsonObject, 'unitPrice').AsDecimal();
            Item."Unit Price" := GetFieldValue(ItemJsonObject, 'unitCost').AsDecimal();
            Item."Item Category Code" := CopyStr(GetFieldValue(ItemJsonObject, 'itemCategoryCode').AsCode(), 1, MaxStrLen(Item."Item Category Code"));

            Item."Base Unit of Measure" := CopyStr(GetFieldValue(ItemJsonObject, 'baseUnitOfMeasure').AsCode(), 1, MaxStrLen(Item."Base Unit of Measure"));
            Item."Gen. Prod. Posting Group" := CopyStr(GetFieldValue(ItemJsonObject, 'genProdPostingGroup').AsCode(), 1, MaxStrLen(Item."Gen. Prod. Posting Group"));
            Item."VAT Prod. Posting Group" := CopyStr(GetFieldValue(ItemJsonObject, 'vatProdPostingGroup').AsCode(), 1, MaxStrLen(Item."VAT Prod. Posting Group"));
            Item."Inventory Posting Group" := CopyStr(GetFieldValue(ItemJsonObject, 'inventoryPostGroup').AsCode(), 1, MaxStrLen(Item."Inventory Posting Group"));


            LoadImage(Item, ItemJsonObject);


            Item.Modify(true);
        end;
    end;

    local procedure LoadImage(var Item: Record Item; ItemJsonObject: JsonObject)
    var
        Base64Convert: Codeunit "Base64 Convert";
        tempBlob: Codeunit "Temp Blob";
        ImageDataBase64: Text;
        PictureName: Text;
        Mime: Text;
        InStream: InStream;
        OutStream: OutStream;
    begin
        ImageDataBase64 := GetFieldValue(ItemJsonObject, 'imageDataBase64').AsText();
        if ImageDataBase64 = 'No Content' then
            exit;

        TempBlob.CreateOutStream(OutStream);
        Base64Convert.FromBase64(ImageDataBase64, OutStream);
        TempBlob.CreateInStream(InStream);

        PictureName := GetFieldValue(ItemJsonObject, 'pictureName').AsText();
        Mime := GetFieldValue(ItemJsonObject, 'mime').AsText();

        Item.Picture.ImportStream(InStream, PictureName, Mime);
    end;

    procedure GetFieldValue(var JsonObject: JsonObject; FieldName: Text): JsonValue
    var
        JsonToken: JsonToken;
    begin
        if not JsonObject.Contains(FieldName) then
            Error('Could not parse JSON. Please try again.');

        JsonObject.Get(FieldName, JsonToken);
        exit(JsonToken.AsValue());
    end;

    local procedure GetItemsAttributes(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping")
    var
        ItemAttribute: Record "Item Attribute";
        ItemAttributeValue: Record "Item Attribute Value";
        //WSGetCompanies: Codeunit "BC WSGetCompanies";
        //JsonValueToken: JsonToken;
        JsonArrayItems: JsonArray;
        JsonTokenItem: JsonToken;
        JsonObjectItem: JsonObject;
        AttributeResponseToken: JsonToken;
        i: integer;
        t: text;
    begin
        //WSGetCompanies.ConnectToAPI(url, JsonValueToken);
        GetAttributeJson(AttributeResponseToken);
        JsonArrayItems := AttributeResponseToken.AsArray();
        for i := 0 to JsonArrayItems.Count() - 1 do begin
            JsonArrayItems.Get(i, JsonTokenItem);
            JsonObjectItem := JsonTokenItem.AsObject();
            JsonObjectItem.WriteTo(t);

            ItemAttribute.SETRANGE(Name, GetFieldValue(JsonObjectItem, 'itemAttributeName').AsText());
            if not ItemAttribute.Findfirst() then begin
                ItemAttribute.Init();
                ItemAttribute.ID := 0;
                ItemAttribute.Insert(true);
                ItemAttribute.Validate(Name, GetFieldValue(JsonObjectItem, 'itemAttributeName').AsText());
                ItemAttribute.Modify(true);
            end;


            ItemAttributeValue.SetRange("Attribute ID", ItemAttribute.Id);
            ItemAttributeValue.SetRange(Value, GetFieldValue(JsonObjectItem, 'itemAttributeValueName').AsText());
            if not ItemAttributeValue.FindFirst() then begin
                ItemAttributeValue.Init();
                ItemAttributeValue."Attribute ID" := ItemAttribute.ID;
                ItemAttributeValue.ID := 0;
                ItemAttributeValue.Insert(true);
                ItemAttributeValue.Validate(Value, CopyStr(GetFieldValue(JsonObjectItem, 'itemAttributeValueName').AsText(), 1, 250));
                ItemAttributeValue.Modify(true);
            end;

            ItemAttributeValueMapping.SetRange("Table ID", GetFieldValue(JsonObjectItem, 'tableID').AsInteger());
            ItemAttributeValueMapping.SetRange("No.", GetFieldValue(JsonObjectItem, 'number').AsCode());
            ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttribute.ID);
            if not ItemAttributeValueMapping.FindFirst() then begin
                ItemAttributeValueMapping.Init();
                ItemAttributeValueMapping.Validate("Table ID", GetFieldValue(JsonObjectItem, 'tableID').AsInteger());
                ItemAttributeValueMapping.Validate("No.", GetFieldValue(JsonObjectItem, 'number').AsCode());
                ItemAttributeValueMapping.Validate("Item Attribute ID", ItemAttribute.ID);
                ItemAttributeValueMapping.Insert(true);
                ItemAttributeValueMapping.Validate("Item Attribute Value ID", ItemAttributeValue.ID);
                ItemAttributeValueMapping.Modify(true);
            end;
        end;
    end;
}