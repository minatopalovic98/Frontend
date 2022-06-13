page 50262 "Filter Shirt"
{
    Caption = 'Shirts';
    PageType = List;
    SourceTable = Item;
    Editable = false;

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
            // action(LoadItems)
            // {
            //     Caption = 'Load Items';
            //     ApplicationArea = All;
            //     ToolTip = 'Refresh of the page.';
            //     Image = WorkCenterLoad;
            //     Promoted = true;
            //     PromotedOnly = true;
            //     PromotedCategory = Process;

            //     RunObject = codeunit "Web Shop Loader";


            // }
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
                    // Cart.Init();

                    // Cart."Item No." := Rec."No.";
                    // Cart.Description := Rec.Description;




                    // Cart.Insert();

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
                begin
                    Rec.SetFilter("No.", AttributeFilter());
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
                    Separators: List of [Text];
                    DescriptionWords: List of [Text];
                    Filter: Text;
                begin
                    Separators.Add(' ');
                    DescriptionWords := Rec.Description.Split(Separators);
                    Filter := DescriptionWords.Get(1) + '*';
                    Item.SetFilter(Description, Filter);
                    Page.Run(Page::"Best Match", Item);
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



            /*action(ClearCart)
            {
                ApplicationArea = All;

                trigger OnAction();
                begin
                    CartRec.DeleteAll();
                end;
            }
            */
        }
    }

    trigger OnOpenPage()
    var
    //WebShopLoader: Codeunit "Web Shop Loader";

    begin
        //WebShopLoader.Run(Rec);
        Rec.SetFilter("Item Category Code", 'WARDROBE');
        Rec.SetFilter(Description, '*shirt*');
    end;

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ItemAttr.Page.LoadItemAttributesData(Rec."No.");
    end;

    local procedure AddNewEntry(var Item: Record Item)
    var
        CartA: Record "Cart";
    begin
        CartA.Init();
        CartA."Entry No." := 0;
        CartA.Insert(true);
        CartA."Item No." := Item."No.";
        CartA.Description := Item.Description;
        CartA.Quantity := 1;
        CartA.Price := Item."Unit Price";
        CartA.Validate(Amount);
        CartA.Modify(true);
    end;

    local procedure AttributeFilter() FilterText: Text
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
        TempItemFilteredFromAttributes.Reset();
        TempItemFilteredFromAttributes.DeleteAll();
        ItemAttributeManagement.FindItemsByAttributes(TempFilterItemAttributesBuffer, TempItemFilteredFromAttributes);
        FilterText := ItemAttributeManagement.GetItemNoFilterText(TempItemFilteredFromAttributes, ParameterCount);
    end;
}