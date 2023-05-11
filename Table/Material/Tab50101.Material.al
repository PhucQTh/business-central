table 50101 Material
{
    Caption = 'Material';
    DataClassification = ToBeClassified;

    fields
    {
        field(11; "Item"; code[20])
        {
            TableRelation = Item;
            Caption = 'Material';
            DataClassification = ToBeClassified;
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

    }
    keys
    {
        key(PK; "Code", "Line No.")
        {
            Clustered = true;
        }
    }

}
