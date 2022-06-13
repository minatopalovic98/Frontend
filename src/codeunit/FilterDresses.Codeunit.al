codeunit 50252 "FilterDresses"
{
    TableNo = Item;

    trigger OnRun()
    var
        Item: Record Item;
        Items: Page "Item List";

    begin
        Item.FindSet();
        Item.SetFilter("Item Category Code", 'WARDROBE');
        Items.Run();

    end;
}
