page 50260 "Best Match"
{
    Caption = 'Best Match';
    PageType = List;
    SourceTable = Item;
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ToolTip = 'Specifies the number of the item.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies what you are selling.';
                    ApplicationArea = All;
                }
                field("Unit Price"; Rec."Unit Price")
                {
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                    ApplicationArea = All;
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
        }
    }

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

    trigger OnAfterGetCurrRecord()
    begin
        CurrPage.ItemAttr.Page.LoadItemAttributesData(Rec."No.");
    end;
}
