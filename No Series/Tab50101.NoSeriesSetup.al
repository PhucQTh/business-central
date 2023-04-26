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
        field(2; "Test No."; Code[10])
        {
            Caption = 'Test No.';
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
