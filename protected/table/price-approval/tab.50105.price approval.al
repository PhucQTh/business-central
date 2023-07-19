table 50105 "Price Approval"
{
    Caption = 'Price Approval';
    DataClassification = ToBeClassified;
    fields
    {
        field(1; No_; Code[20])
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
        field(2; "General explanation"; Blob)
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
        field(6; "Title"; Text[2048])
        {
            Caption = 'Title';
            DataClassification = ToBeClassified;
            NotBlank = true;
        }
        field(7; "PR No."; Code[10])
        {
            Caption = 'PR No.';
            DataClassification = ToBeClassified;
        }
        field(8; "Purpose"; Text[2048])
        {
            Caption = 'Purpose';
            DataClassification = ToBeClassified;
            NotBlank = true;

        }
        field(9; "Due Date"; Date)
        {
            Caption = 'Due Date';
            DataClassification = ToBeClassified;
            NotBlank = true;

        }
        field(10; "Request By"; Code[50])
        {
            Caption = 'User Name';
            Editable = false;
            DataClassification = ToBeClassified;
        }
        field(11; ApprovalType; Enum "Approval Type")
        {
            Caption = 'General Price Approval';
            DataClassification = ToBeClassified;
        }
        field(12; RequestDate; Date)
        {
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
    //!=============================================
    procedure SetContent(Data: Text)
    var
        OutStreamVar: OutStream;
    begin
        Clear("General explanation");
        "General explanation".CreateOutStream(OutStreamVar, TextEncoding::UTF8);
        OutStreamVar.Write(Data);
        if not Rec.Modify(true) then;
    end;

    procedure GetContent() Data: Text
    var
        InStreamVar: InStream;
    begin
        CalcFields("General explanation");
        if not "General explanation".HasValue() then
            exit;
        "General explanation".CreateInStream(InStreamVar, TextEncoding::UTF8);
        InStreamVar.Read(Data);
    end;
    //!=============================================


    var
        NoSeriesSetup: Record "No. Series Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
