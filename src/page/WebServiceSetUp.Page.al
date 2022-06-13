page 50252 "Web Service SetUp"
{
    Caption = 'Web Service Setup';
    PageType = Card;
    SourceTable = "Web Service Setup";
    UsageCategory = Administration;
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            group(General)
            {
                field("Base Url"; Rec."Base Url")
                {
                    ToolTip = 'Specifies the value of the Base Url field.';
                    ApplicationArea = All;
                    ExtendedDatatype = URL;
                }
                field(UserName; Rec.UserName)
                {
                    ToolTip = 'Specifies the value of the UserName field.';
                    ApplicationArea = All;
                }
                field(Password; Rec.Password)
                {
                    ToolTip = 'Specifies the value of the Password field.';
                    ApplicationArea = All;
                    ExtendedDatatype = Masked;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        If not Rec.Get() then begin
            Rec.Init();
            Rec."Base Url" := GetDefaultBaseURL();
            Rec.Insert();
        end;
    end;

    local procedure GetDefaultBaseURL(): Text[250]
    begin
        exit('http://betsandbox.westeurope.cloudapp.azure.com:7048/E1/api/v2.0');
    end;
}
