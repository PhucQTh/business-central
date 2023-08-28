table 50111 "PU Department"
{
    Caption = 'PU Department';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; Employee; Text[50])
        {
            Caption = 'Employee';
            DataClassification = ToBeClassified;
        }
        field(2; "Materials/Services"; Text[2048])
        {
            Caption = 'Materials/Services';
            DataClassification = ToBeClassified;
        }
        field(3; id; Integer)
        {
            Caption = 'id';
            DataClassification = ToBeClassified;
            AutoIncrement = true;
        }
    }
    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
}
