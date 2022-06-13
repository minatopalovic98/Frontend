page 50255 "UserActivity"
{

    PageType = CardPart;
    SourceTable = "User Activity";
    RefreshOnActivate = true;

    layout
    {
        area(content)
        {

            cuegroup(Group)
            {
                Caption = ' ';
                //CuegroupLayout = Wide;


                field(Field1; CountMan())
                {
                    ApplicationArea = All;
                    Caption = 'Man';
                    ToolTip = 'Shows all man clothes';
                    Style = Favorable;

                    trigger OnDrillDown()
                    var
                        Item: Record Item;
                    begin
                        Item.SetFilter("No.", GetMaleFilterItems());
                        Page.Run(Page::"Web Shop", Item);
                    end;
                }
                field(Field2; CountWoman())
                {
                    ApplicationArea = All;
                    Caption = 'Woman';
                    ToolTip = 'Shows all woman clothes';

                    trigger OnDrillDown()
                    var
                        Item: Record Item;
                    begin
                        Item.SetFilter("No.", GetFemaleFilterItems());
                        //Item.SetFilter(Description, 'Blue*');
                        Page.Run(Page::"Web Shop", Item);
                    end;

                }
            }
        }
    }

    trigger OnOpenPage()
    var
        femaleFilterItems: text;
    begin
        /*
        Rec.Reset();
        if not Rec.Get() then begin
            Rec.Init();
            Rec.Insert();
        end;
*/
        femaleFilterItems := GetFemaleFilterItems();
        //Message('Tu sam!');


    end;

    local procedure GetFemaleFilterItems() FilterText: Text
    var
        //Item: record Item;
        TempItemFilteredFromAttributes: Record Item temporary;
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement: Codeunit "Item Attribute Management";
        //FilterText: Text;
        ParameterCount: Integer;
    //Count: Integer;
    begin
        TempFilterItemAttributesBuffer.Init();
        TempFilterItemAttributesBuffer.Validate(Attribute, 'Type');
        TempFilterItemAttributesBuffer.Validate(Value, 'Woman');
        TempFilterItemAttributesBuffer.Insert();

        TempItemFilteredFromAttributes.Reset();
        TempItemFilteredFromAttributes.DeleteAll();
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
        FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);

        //FilterText := '<>' + FilterText;
        //Item.SetFilter("No.", FilterText);
        //Count := Item.Count();
        //Message(format(Count));
    end;

    local procedure CountWoman() CountItems: Integer
    var
        Item: Record Item;
    begin
        Item.SetFilter("No.", GetFemaleFilterItems());
        CountItems := Item.Count();
    end;


    local procedure GetMaleFilterItems() FilterText: Text
    var
        //Item: record Item;
        TempItemFilteredFromAttributes: Record Item temporary;
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement: Codeunit "Item Attribute Management";
        //FilterText: Text;
        ParameterCount: Integer;
    //Count: Integer;
    begin
        TempFilterItemAttributesBuffer.Init();
        TempFilterItemAttributesBuffer.Validate(Attribute, 'Type');
        TempFilterItemAttributesBuffer.Validate(Value, '''Man''');
        TempFilterItemAttributesBuffer.Insert();

        TempItemFilteredFromAttributes.Reset();
        TempItemFilteredFromAttributes.DeleteAll();
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
        FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);

        //FilterText := '<>' + FilterText;
        //Item.SetFilter("No.", FilterText);
        //Count := Item.Count();
        //Message(format(Count));
    end;

    local procedure CountMan() CountItems: Integer
    var
        Item: Record Item;
    begin
        Item.SetFilter("No.", GetMaleFilterItems());
        CountItems := Item.Count();
    end;

}
