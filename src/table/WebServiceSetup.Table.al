table 50250 "Web Service Setup"
{
    Caption = 'Web Service Setup';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Primary key"; Code[20])
        {
            Caption = 'Primary key';
            DataClassification = SystemMetadata;
        }
        field(2; "Base Url"; Text[250])
        {
            Caption = 'Base Url';
            DataClassification = OrganizationIdentifiableInformation;
        }
        field(3; UserName; Text[100])
        {
            Caption = 'UserName';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(4; Password; Text[100])
        {
            Caption = 'Password';
            DataClassification = EndUserIdentifiableInformation;
        }
    }
    keys
    {
        key(PK; "Primary key")
        {
            Clustered = true;
        }
    }
}
