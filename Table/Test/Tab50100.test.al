table 50110 Test
{
    Caption = 'Test';
    DataClassification = ToBeClassified;

    fields
    {

        field(1; No_; Code[10])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "No_" <> xRec."No_" then begin
                    NoSeriesSetup.Get();
                    NoSeriesMgt.TestManual(NoSeriesSetup."Test No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; comment; Text[200])
        {
            Caption = 'comment';
            DataClassification = ToBeClassified;
        }
        field(4; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; no_)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No_" = '' then begin
            NoSeriesSetup.Get();
            NoSeriesSetup.TestField("Test No.");
            NoSeriesMgt.InitSeries(NoSeriesSetup."Test No.", xRec."No. Series", 0D, "No_", "No. Series");
        end;
    end;

    var
        NoSeriesSetup: Record "No. Series Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
