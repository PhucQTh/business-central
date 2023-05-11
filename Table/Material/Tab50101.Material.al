table 50101 Material
{
    Caption = 'Material';
    DataClassification = ToBeClassified;

    fields
    {
        field(11; "ItemNo"; code[20])
        {
            TableRelation = Item;
            Caption = 'Material';
            DataClassification = ToBeClassified;
            trigger OnValidate()
            var
                ItemRec: Record Item;
            begin
                if ItemRec.Get(ItemNo) then
                    Description := ItemRec.Description;
                Unit := ItemRec."Base Unit of Measure";
            end;

        }
        field(2; "Product code of Manufacturer"; Text[100])
        {
            Caption = 'Product code of Manufacturer';
            DataClassification = ToBeClassified;
        }
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Price Approval"."No_";
            DataClassification = ToBeClassified;
        }
        field(5; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
        field(3; Supplier; Text[200])
        {
            Caption = 'Supplier';
            DataClassification = ToBeClassified;
        }
        field(4; Price; Text[200])
        {
            Caption = 'Price';
            DataClassification = ToBeClassified;
        }

        field(6; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(7; Unit; code[10])
        {
            Caption = 'Unit';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; "Code", "Line No.")
        {
            Clustered = true;
        }
    }

}
