table 50102 MaterialItem
{
    Caption = 'MaterialItem';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            TableRelation = "Material"."Code";
            DataClassification = ToBeClassified;
        }
        field(2; "Material No."; Integer)
        {
            Caption = 'Line No.';
        }

        field(3; "ItemNo"; code[20])
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
            end;

        }
        field(4; Description; Text[100])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
            Editable = false;
            NotBlank = true;

        }
        field(5; Unit; Enum "Item Unit")
        {
            Caption = 'Unit';
            DataClassification = ToBeClassified;
            // Editable = false;
            NotBlank = true;

        }
        field(6; "Quantity"; Text[100])
        {
            Caption = 'Quantity';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code", "Material No.", "ItemNo")
        {
            Clustered = true;
        }
    }
}
