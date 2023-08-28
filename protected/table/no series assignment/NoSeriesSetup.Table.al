table 50103 "No. Series Setup"
{
    Caption = 'No. Series Setup';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Primary Key"; Code[10])
        {

            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        //! Assign no. code 
        field(2; "Price Approval No."; Code[20])
        {
            Caption = 'Price Approval No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(3; "Purchase Request No."; Code[20])
        {
            Caption = 'Price Approval No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(4; "Cylinder Request No."; Code[20])
        {
            Caption = 'Cylinder Request No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }
    //! Check record has one item
    procedure GetRecordOnce()
    begin
        if RecordHasBeenRead then
            exit;
        Get;
        RecordHasBeenRead := true;
    end;

    var
        RecordHasBeenRead: Boolean;
}
