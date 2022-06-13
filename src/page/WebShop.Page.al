page 50253 "Web Shop"
{
    Caption = 'Web Shop';
    PageType = List;
    UsageCategory = Lists;
    ApplicationArea = All;
    SourceTable = Item;
    //SourceTableTemporary = true;
    Editable = false;
    AdditionalSearchTerms = 'wardorbe,shirts,trousers,dress,skirts';

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the number of the item.';
                }
                field(Name; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies what you are selling.';
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field(Picture; Rec.Picture)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the picture that has been inserted for the item.';
                }
            }
        }
        area(Factboxes)
        {
            // Tvoj Cart ide ovde, on je u sustini list part page sa nekom tablicom koja ima kompleksni primarni kljuc koji se sastoji od item id
            part(ItemPicture; "Item Picture")
            {
                Caption = 'Picture';
                ApplicationArea = all;
                SubPageLink = "No." = field("No.");

            }
            part(ItemAttr; "Item Attributes Factbox")
            {
                Caption = 'Item Attribute';
                ApplicationArea = all;

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(LoadItems)
            {
                Caption = 'Load Items';
                ApplicationArea = All;
                ToolTip = 'Refresh of the page.';
                Image = WorkCenterLoad;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = codeunit "Web Shop Loader";


            }
            action(AddToCart)
            {
                Caption = 'Add To Cart';
                ApplicationArea = All;
                ToolTip = 'Adds the selected item to Cart.';
                Image = Add;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                ShortcutKey = 'Return';

                trigger OnAction();
                var
                    Cart: Record Cart;
                begin


                    Cart.SetRange("Item No.", Rec."No.");

                    if Cart.FindFirst() then begin
                        Cart.Validate(Quantity, Cart.Quantity + 1);
                        Cart.Validate(Amount);
                        Cart.Modify(true);
                    end else
                        AddNewEntry(Rec);

                    Message('You have successfully added item %1 to Cart! ✔️', Cart.Description);
                end;
            }
            action(Cart)
            {
                Caption = 'Cart';
                ApplicationArea = All;
                ToolTip = 'Shows all selected items.';
                Image = Bin;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                RunObject = page Cart;
            }
            action(AttributeFilter1)
            {
                Caption = 'Filter';
                ApplicationArea = All;
                ToolTip = 'Filters Items with auttribute value';
                Image = Filter;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    GenderText: Text;
                begin
                    ItemAttributeValueMapping.SetRange("Table ID", Database::Item);
                    ItemAttributeValueMapping.SetRange("No.", Rec."No.");
                    ItemAttributeValueMapping.SetRange("Item Attribute ID", 7);

                    ItemAttributeValueMapping.FindFirst();

                    if ItemAttributeValueMapping."Item Attribute Value ID" = 78 then
                        GenderText := '''Man'''
                    else
                        GenderText := '''Woman''';






                    Rec.SetFilter("No.", AttributeFilter(GenderText));
                end;
            }
            action(BestMatch)
            {
                Caption = 'Best Match 🤍';
                ApplicationArea = All;
                ToolTip = 'Filters Items with auttribute value';
                Image = Info;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;


                trigger OnAction()
                var
                    Item: Record Item;
                    ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    TempItemFilteredFromAttributes: Record Item temporary;
                    TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
                    ItemAttributeManagement: Codeunit "Item Attribute Management";
                    Separators: List of [Text];
                    DescriptionWords: List of [Text];
                    ColorText: Text;
                    GenderText: Text;
                    ParameterCount: Integer;
                    FilterText: Text;

                begin
                    Separators.Add(' ');
                    DescriptionWords := Rec.Description.Split(Separators);
                    ColorText := DescriptionWords.Get(1) + '*';
                    Item.SetFilter(Description, ColorText);

                    ItemAttributeValueMapping.SetRange("Table ID", Database::Item);
                    ItemAttributeValueMapping.SetRange("No.", Rec."No.");
                    ItemAttributeValueMapping.SetRange("Item Attribute ID", 7);

                    ItemAttributeValueMapping.FindFirst();

                    if ItemAttributeValueMapping."Item Attribute Value ID" = 78 then
                        GenderText := '''Man'''
                    else
                        GenderText := '''Woman''';


                    TempFilterItemAttributesBuffer.Init();
                    TempFilterItemAttributesBuffer.Validate(Attribute, 'Type');
                    TempFilterItemAttributesBuffer.Validate(Value, GenderText);
                    TempFilterItemAttributesBuffer.Insert();

                    TempItemFilteredFromAttributes.Reset();
                    TempItemFilteredFromAttributes.DeleteAll();
                    ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
                    FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);

                    Item.SetFilter("No.", FilterText);

                    Page.Run(Page::"Best Match", Item);
                end;
            }

        }
    }

    trigger OnOpenPage()
    begin
        Rec.SetFilter("Item Category Code", 'WARDROBE');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ItemAttr.Page.LoadItemAttributesData(Rec."No.");
    end;

    local procedure AddNewEntry(Item: Record Item)
    var
        CartA: Record "Cart";
    begin
        CartA.Init();
        CartA.Insert(true);
        CartA."Item No." := Item."No.";
        CartA.Description := Item.Description;
        CartA.Quantity := 1;
        CartA.Price := Item."Unit Price";
        CartA.Validate(Amount);
        CartA.Modify(true);
    end;

    local procedure AttributeFilter(GenderText: Text) FilterText: Text
    var
        TempItemFilteredFromAttributes: Record Item temporary;
        TempFilterItemAttributesBuffer: Record "Filter Item Attributes Buffer" temporary;
        ItemAttributeManagement: Codeunit "Item Attribute Management";
        ParameterCount: Integer;
        FilterPageID: Integer;
        CloseAction: Action;
    begin

        FilterPageID := PAGE::"Filter Items by Attribute";
        CloseAction := PAGE.RunModal(FilterPageID, TempFilterItemAttributesBuffer);

        TempFilterItemAttributesBuffer.Validate(Attribute, 'Type');
        TempFilterItemAttributesBuffer.Validate(Value, GenderText);
        TempFilterItemAttributesBuffer.Insert(true);

        TempItemFilteredFromAttributes.Reset();
        TempItemFilteredFromAttributes.DeleteAll();
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
        FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);
    end;
}