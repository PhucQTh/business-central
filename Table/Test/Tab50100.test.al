table 50110 "Price Approval"
{
    Caption = 'Price Approval';
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
                    NoSeriesMgt.TestManual(NoSeriesSetup."Price Approval No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; "General explanation"; Text[200])
        {
            Caption = 'General explanation';
            DataClassification = ToBeClassified;
        }
        field(3; Status; Enum "Custom Approval Enum")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(4; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(5; "Department"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Title"; Text[100])
        {
            Caption = 'Title';
            DataClassification = ToBeClassified;
        }
        field(7; "PR No."; Code[10])
        {
            Caption = 'PR No.';
            DataClassification = ToBeClassified;
        }
        field(8; "Purpose"; Code[10])
        {
            Caption = 'Purpose';
            DataClassification = ToBeClassified;
        }
        field(9; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
        }
        field(10; "User ID"; Text[200])
        {
            Caption = 'General explanation';
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
            NoSeriesSetup.TestField("Price Approval No.");
            NoSeriesMgt.InitSeries(NoSeriesSetup."Price Approval No.", xRec."No. Series", 0D, "No_", "No. Series");
        end;
    end;

    var
        NoSeriesSetup: Record "No. Series Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
