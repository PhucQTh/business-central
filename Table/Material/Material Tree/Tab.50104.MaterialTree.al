table 50104 "Material Tree"
{
    Caption = 'Material Tree';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = SystemMetadata;
        }
        field(2; Indentation; Integer)
        {
            Caption = 'Indentation';
            DataClassification = SystemMetadata;
        }
        field(3; "Manufacturer's code:"; Text[100])
        {
            Caption = 'Manufacturer''s code:';
            DataClassification = SystemMetadata;
        }
        field(4; Supplier; Text[200])
        {
            Caption = 'Supplier';
            DataClassification = SystemMetadata;
        }
        field(5; "Price Term"; code[10])
        {
            Caption = 'Price Term';
            DataClassification = SystemMetadata;
        }

        field(6; Price; Text[200])
        {
            Caption = 'Price';
            DataClassification = SystemMetadata;
        }
        field(7; "Delivery"; code[10])
        {
            Caption = 'Delivery';
            DataClassification = SystemMetadata;
        }
        field(8; "Pallet/No pallet"; code[10])
        {
            Caption = 'Pallet/No pallet';
            DataClassification = SystemMetadata;
        }
        field(9; "Roll length"; code[10])
        {
            Caption = 'Price Term';
            DataClassification = SystemMetadata;
        }
        field(10; "Payment term"; code[10])
        {
            Caption = 'Payment term';
            DataClassification = SystemMetadata;
        }
        field(11; "Price Note"; Text[2048])
        {
            Caption = 'Payment term';
            DataClassification = SystemMetadata;
        }
        //!===================================================
        field(12; "ItemNo"; code[20])
        {
            Caption = 'Material';
            DataClassification = SystemMetadata;
        }
        field(13; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = SystemMetadata;
        }
        field(14; Unit; code[10])
        {
            Caption = 'Unit';
            DataClassification = SystemMetadata;

        }
        field(15; "Quantity"; Text[100])
        {
            Caption = 'Quantity';
            DataClassification = SystemMetadata;
        }
        //!===================================================
        field(16; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = SystemMetadata;
            TableRelation = "Price Approval"."No_";

        }
        field(17; "Line No."; Integer)
        {
            Caption = 'Line No.';
            DataClassification = SystemMetadata;
        }

    }
    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }

    }

}
