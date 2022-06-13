page 50251 "Cart"
{
    ApplicationArea = All;
    Caption = 'Cart';
    PageType = List;
    SourceTable = Cart;
    UsageCategory = Administration;
    Editable = false;
    DeleteAllowed = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Item No."; Rec."Item No.")
                {
                    ToolTip = 'Specifies the value of the Item No. field.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the value of the Description field.';
                    ApplicationArea = All;
                }
                field(Quantity; Rec.Quantity)
                {
                    ToolTip = 'Specifies the value of the Quantity field.';
                    ApplicationArea = All;
                }
                field(Price; Rec.Price)
                {
                    ToolTip = 'Specifies the value of the Price field.';
                    ApplicationArea = All;
                }
                field(Amount; Rec.Amount)
                {
                    ToolTip = 'Specifies the value of the Amount field.';
                    ApplicationArea = All;
                }

            }
            grid(Total)
            {
                GridLayout = Columns;
                group(col1)
                {
                    Caption = ' ';
                    field(TotalAmount1; GetTotalAmount())
                    {
                        Caption = 'Total Amount';
                        ToolTip = 'Specifies the value of the Total Amount field.';
                        ApplicationArea = All;
                        Style = StrongAccent;
                    }
                }
                // group(col2)
                // {
                //     field(TotalAmount; GetTotalAmount())
                //     {
                //         Caption = 'Total Amount';
                //         ToolTip = 'Specifies the value of the Total Amount field.';
                //         ApplicationArea = All;
                //     }
                // }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(delete)
            {
                Caption = 'Delete item';
                ApplicationArea = All;
                ToolTip = 'Delete selected item form cart.';
                Image = Delete;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cart: Record Cart;
                begin
                    cart.SetRange("Entry No.", rec."Entry No.");
                    if cart.FindFirst() then
                        cart.Delete()
                    else
                        Error('Greška');

                end;
            }
            action(deleteAll)
            {
                Caption = 'Delete all';
                ApplicationArea = All;
                ToolTip = 'Delete all items form cart.';
                Image = DeleteAllBreakpoints;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    cart: Record Cart;
                begin
                    cart.DeleteAll();
                end;
            }
            action(Buy)
            {
                Caption = 'Check out';
                ApplicationArea = All;
                ToolTip = 'Buy all items that you have selected.';
                Image = Approval;
                Promoted = true;
                PromotedOnly = true;
                PromotedCategory = Process;
                //ShortcutKey = 'Return';
                //RunObject = page "User Credentials";

                trigger OnAction()
                var
                    Cart: Record Cart;
                begin
                    if Cart.IsEmpty then
                        Message('The cart is empty! You have to first put some items in cart!')
                    else begin
                        Page.RunModal(Page::"User Credentials");
                        CurrPage.Update();
                    end;
                end;
            }
        }
    }
    local procedure GetTotalAmount(): Decimal
    var
        CartEntry: Record "Cart";
    begin
        CartEntry.CalcSums(Amount);
        exit(CartEntry.Amount)
    end;

    // trigger OnOpenPage()
    // begin
    //     Rec.SetRange(User, UserId());
    // end;
}
