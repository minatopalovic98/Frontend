table 50253 "User Activity"
{
    Caption = 'User Activity';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primery key"; Code[10])
        {
            Caption = 'Primery key';
            DataClassification = SystemMetadata;
        }
        field(2; "No. of male clothes"; Integer)
        {
            Caption = 'No. of male clothes';
            FieldClass = FlowField;
            CalcFormula = count(Item where("Item Category Code" = filter('*WARDROBE*')));
        }
        field(3; "No. of female clothes"; Integer)
        {
            Caption = 'No. of female clothes';
            FieldClass = FlowField;
            CalcFormula = count(Item where("Item Category Code" = filter('*WARDROBE*')));
        }
    }
    keys
    {
        key(PK; "Primery key")
        {
            Clustered = true;
        }
    }
}
