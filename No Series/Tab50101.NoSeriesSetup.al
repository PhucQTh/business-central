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
        field(2; "Price Approval No."; Code[10])
        {
            Caption = 'Price Approval No.';
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
