table 50101 Material
{
    Caption = 'Material';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = "Purchase Request Info"."No_";
            DataClassification = ToBeClassified;
        }
        field(2; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        //!------------------------------------SUPLIER
        field(3; "Manufacturer's code:"; Text[100])
        {
            Caption = 'Manufacturer''s code:';
            DataClassification = ToBeClassified;
            NotBlank = true;

        }
        field(4; Supplier; Text[200])
        {
            Caption = 'Supplier';
            DataClassification = ToBeClassified;
            NotBlank = true;

        }
        field(5; "Price Term"; Text[200])
        {
            Caption = 'Price Term';
            DataClassification = ToBeClassified;
        }

        field(6; Price; Text[200])
        {
            Caption = 'Price';
            DataClassification = ToBeClassified;
            NotBlank = true;

        }
        field(7; "Delivery"; Text[100])
        {
            Caption = 'Delivery';
            DataClassification = ToBeClassified;
        }
        field(8; "Pallet/No pallet"; Text[100])
        {
            Caption = 'Pallet/No pallet';
            DataClassification = ToBeClassified;
        }
        field(9; "Roll length"; Text[50])
        {
            Caption = 'Price Term';
            DataClassification = ToBeClassified;
        }
        field(10; "Payment term"; Text[200])
        {
            Caption = 'Payment term';
            DataClassification = ToBeClassified;
        }
        field(11; "Price Note"; Blob)
        {
            Caption = 'Payment term';
            DataClassification = ToBeClassified;
        }
        field(12; "CC Recipient"; Text[2048])
        {
            DataClassification = ToBeClassified;

        }
    }
    keys
    {
        key(PK; "Code", "Line No.")
        {
            Clustered = true;
        }
    }
    //!=============================================
    procedure SetContent(Data: Text)
    var
        OutStreamVar: OutStream;
    begin
        Clear("Price Note");
        "Price Note".CreateOutStream(OutStreamVar);
        OutStreamVar.Write(Data);
        if not Rec.Modify(true) then;
    end;

    procedure GetContent() Data: Text
    var
        InStreamVar: InStream;
    begin
        CalcFields("Price Note");
        if not "Price Note".HasValue() then
            exit;
        "Price Note".CreateInStream(InStreamVar);
        InStreamVar.Read(Data);
    end;
    //!=============================================
}
