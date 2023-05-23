table 50101 Material
{
    Caption = 'Material';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            TableRelation = "Price Approval"."No_";
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
        field(5; "Price Term"; code[10])
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
        field(7; "Delivery"; code[10])
        {
            Caption = 'Delivery';
            DataClassification = ToBeClassified;
        }
        field(8; "Pallet/No pallet"; code[10])
        {
            Caption = 'Pallet/No pallet';
            DataClassification = ToBeClassified;
        }
        field(9; "Roll length"; code[10])
        {
            Caption = 'Price Term';
            DataClassification = ToBeClassified;
        }
        field(10; "Payment term"; code[10])
        {
            Caption = 'Payment term';
            DataClassification = ToBeClassified;
        }
        field(11; "Price Note"; Text[2048])
        {
            Caption = 'Payment term';
            DataClassification = ToBeClassified;
        }
        //!------------------------------------ITEM
        // field(12; Description; Text[100])
        // {
        //     Caption = 'Description';
        //     DataClassification = ToBeClassified;
        //     Editable = false;
        //     NotBlank = true;

        // }
        // field(13; Unit; code[10])
        // {
        //     Caption = 'Unit';
        //     DataClassification = ToBeClassified;
        //     Editable = false;
        //     NotBlank = true;

        // }
        // field(14; "Quantity"; Text[100])
        // {
        //     Caption = 'Quantity';
        //     DataClassification = ToBeClassified;
        // }

        // field(15; "ItemNo"; code[20])
        // {
        //     TableRelation = Item;
        //     Caption = 'Material';
        //     DataClassification = ToBeClassified;
        //     trigger OnValidate()
        //     var
        //         ItemRec: Record Item;
        //     begin
        //         if ItemRec.Get(ItemNo) then
        //             Description := ItemRec.Description;
        //         Unit := ItemRec."Base Unit of Measure";
        //     end;

        // }



    }
    keys
    {
        key(PK; "Code", "Line No.")
        {
            Clustered = true;
        }
    }

}
