table 50251 "Cart"
{
    DataClassification = CustomerContent;


    fields
    {
        field(1; "Entry No."; Integer)
        {
            DataClassification = SystemMetadata;
            AutoIncrement = true;
        }
        field(2; "Item No."; Code[20])
        {
            DataClassification = CustomerContent;
            TableRelation = Item."No.";
            Caption = 'Item No.';
        }
        field(3; Description; Text[250])
        {
            DataClassification = CustomerContent;
            Caption = 'Description';
        }
        field(4; Quantity; Integer)
        {
            DataClassification = CustomerContent;
            Caption = 'Quantity';
        }
        field(5; Price; Decimal)
        {
            Caption = 'Price';
            DataClassification = AccountData;
            Editable = false;

            trigger OnValidate()
            begin
                Validate(Amount);
            end;
        }
        field(6; Amount; Decimal)
        {
            Caption = 'Amount';
            DataClassification = AccountData;
            Editable = false;

            trigger OnValidate()
            begin
                Amount := Quantity * Price;
            end;
        }
        // field(7; User; Text[50])
        // {
        //     DataClassification = AccountData;
        // }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        {
            SumIndexFields = Quantity;
        }
    }

    // trigger OnInsert()
    // var

    // begin

    //     //dodaj copyStr
    //     User := CopyStr(UserId(), 1, 50);
    // end;
}