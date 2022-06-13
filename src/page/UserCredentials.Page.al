page 50254 "User Credentials"
{
    Caption = 'Please enter your personal informations: ';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(Name; Name)
                {
                    Caption = 'Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
                field(PhoneNumber; PhoneNumber)
                {
                    Caption = 'Phone number';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Phone number field.';
                }
                field(Email; Email)
                {
                    Caption = 'E-mail';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the E-mail field.';
                }
                field(Address; Address)
                {
                    Caption = 'Address';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
                field(CardNo; CardNo)
                {
                    Caption = 'Card No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Address field.';
                }
            }
        }
    }

    var
        Name: Text;
        PhoneNumber: Text;
        Address: Text;
        Email: Text;
        CardNo: Text;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var

        Cart: record Cart;
        PatchCustomer: Codeunit "Patch Customer";
        PostSalesInvoice: Codeunit "Post Sales Invoice";
    begin
        if CloseAction = Action::OK then begin
            PatchCustomer.ModifyCustomer(CustomerPayload());
            PostSalesInvoice.PostInvoice(ItemPayload());

            Cart.DeleteAll();

            // UserSetUp.Get(UserId());
            // UserSetUp."E-Mail" := CopyStr(Email, 1, 100);
            // UserSetUp."Phone No." := CopyStr(PhoneNumber, 1, 10);
            // UserSetUp.Modify();

            // Cart.FindSet();
            // repeat
            //     PostedCart.TransferFields(Cart);
            //     PostedCart.Insert();
            //     Cart.Delete();
            // until Cart.Next() = 0;
        end;
    end;

    // trigger OnOpenPage()
    // var
    //     UserSetUp: record "User Setup";
    // begin
    //     if not UserSetUp.Get(UserId()) then begin
    //         UserSetUp.Init();
    //         UserSetUp."User ID" := UserId();
    //         UserSetUp.Insert();
    //     end;
    //     //Name := UserSetUp."User ID";
    //     Email := UserSetUp."E-Mail";
    //     PhoneNumber := UserSetUp."Phone No.";

    // end;

    procedure CustomerPayload() CustomerJsonText: Text
    var
        CustomerJson: JsonObject;
    begin
        CustomerJson.Add('displayName', Name);
        CustomerJson.Add('phoneNumber', PhoneNumber);
        CustomerJson.Add('addressLine1', Address);
        CustomerJson.Add('email', Email);
        CustomerJson.WriteTo(CustomerJsonText);
    end;

    procedure ItemPayload() ItemJsonText: Text
    var
        Items: Record Cart;
        Invoice: JsonObject;
        SalesLineObject: JsonObject;
        SalesLineArray: JsonArray;
    begin
        Items.FindSet();

        Invoice.Add('customerNumber', 'C00020');

        repeat
            Clear(SalesLineObject);
            SalesLineObject.Add('lineType', 'Item');
            SalesLineObject.Add('lineObjectNumber', Items."Item No.");
            SalesLineObject.Add('quantity', Items.Quantity);

            SalesLineArray.Add(SalesLineObject);

        until Items.Next() = 0;

        Invoice.Add('salesInvoiceLines', SalesLineArray);
        Invoice.WriteTo(ItemJsonText);

    end;
}