table 50106 "Email Template"
{
    Caption = 'Email Template';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Key"; Code[200])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;

        }

        field(3; Body; Blob)
        {
            Caption = 'Body';
            DataClassification = ToBeClassified;
        }
        field(4; Subject; Text[2048])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Key")
        {
            Clustered = true;
        }
    }
    //!=============================================
    procedure SetContent(Data: Text)
    var
        OutStreamVar: OutStream;
    begin
        Clear("Body");
        "Body".CreateOutStream(OutStreamVar, TextEncoding::UTF8);
        OutStreamVar.Write(Data);
        if not Rec.Modify(true) then;
    end;

    procedure GetContent() Data: Text
    var
        InStreamVar: InStream;
    begin
        CalcFields("Body");
        if not "Body".HasValue() then begin
            exit;
        end;
        "Body".CreateInStream(InStreamVar, TextEncoding::UTF8);
        InStreamVar.Read(Data);
    end;
    //!=============================================


}
