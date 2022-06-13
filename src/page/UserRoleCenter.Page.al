page 50250 "UserRoleCenter"
{
    Caption = 'UserRoleCenter';
    PageType = RoleCenter;

    layout
    {
        area(RoleCenter)
        {
            part(HeadLine; "HeadLine User")
            {
                ApplicationArea = All;
            }
            group(MyGroup)
            {
                Caption = 'RoleCenter Group';

                part(UserActivity; "UserActivity")
                {
                    Caption = ' ';


                }
            }

        }
    }
    actions
    {
        area(Embedding)
        {
            action(Items)
            {
                Caption = 'Items';
                ApplicationArea = All;

                RunObject = page "Web Shop";
            }
            action(Dress)
            {
                Caption = 'Dress';
                ApplicationArea = All;

                RunObject = page "Filter Dresses";
            }
            action(Shirts)
            {
                Caption = 'Shirts';
                ApplicationArea = All;

                RunObject = page "Filter Shirt";
            }
            action(Trousers)
            {
                Caption = 'Trousers';
                ApplicationArea = All;

                RunObject = page "Filter Trousesrs";
            }

            action(Skirts)
            {
                Caption = 'Skirts';
                ApplicationArea = All;

                RunObject = page "Filter Skirt";
            }

        }
        area(Processing)
        {

            action(Cart)
            {
                Caption = 'Cart';
                ToolTip = 'Cart';
                ApplicationArea = All;

                RunObject = page "Cart";
            }
            // action(PostedCart)
            // {
            //     Caption = 'Purchased clothes';
            //     ToolTip = 'Purchased clothes';
            //     ApplicationArea = All;

            //     RunObject = page "Posted Cart";
            // }
        }
    }


}
