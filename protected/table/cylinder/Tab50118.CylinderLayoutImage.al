table 50118 "Cylinder Layout Image"
{
    Caption = 'Cylinder Layout Image';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            Caption = 'id';
        }
        field(2; "Request ID"; Code[20])
        {
            Caption = 'Request ID';
        }
        field(3; image; MediaSet)
        {
            Caption = 'image';
        }
    }
    keys
    {
        key(PK; id, "Request ID")
        {
            Clustered = true;
        }
    }
}
