page 50256 "HeadLine User"
{
    Caption = 'HeadLine User';
    PageType = HeadlinePart;
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {
            group(Control1)
            {
                ShowCaption = false;
                field(GreetingText; GetHeadingText())
                {
                    ApplicationArea = All;
                    Caption = 'Greeting headline';
                    Editable = true;
                }
                // field(GreetingText2; GetHeadingText2())
                // {
                //     ApplicationArea = All;
                //     Caption = 'Heading with Link';
                //     Editable = true;

                //     trigger OnDrillDown()
                //     var
                //         DrillDownURLTxt: Label 'https://betsandbox.westeurope.cloudapp.azure.com/E1/', Locked = True;
                //     begin
                //         Hyperlink(DrillDownURLTxt)
                //     end;
                // }

            }

            group(Control2)
            {
                field(GreetingText3; GetHeadingText2())
                {
                    ApplicationArea = All;
                    Caption = 'Greeting headline';
                    Editable = true;
                }
            }

        }
    }


    trigger OnOpenPage()
    begin
        RCHeadlinesPageCommon.HeadlineOnOpenPage(Page::"Headline RC Business Manager");
    end;

    local procedure GetHeadingText(): Text
    begin
        Exit('Hi customer! Welcome to my shop! 🤗');
    end;

    local procedure GetHeadingText2(): Text
    begin
        Exit('Everybody loves shopping! 😍');
    end;

    var
        RCHeadlinesPageCommon: Codeunit "RC Headlines Page Common";
}
