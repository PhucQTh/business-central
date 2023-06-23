table 50110 "Purchase Request Confirm"
{
    Caption = 'Purchase Request Confirm';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; RequestCode; Code[10])
        {
            Caption = 'RequestCode';
            DataClassification = ToBeClassified;
        }

        field(3; Status; Enum "Confirm Status")
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
        }
        field(4; "Confirm by"; Text[200])
        {

            Caption = 'Confirm by';
            DataClassification = ToBeClassified;
        }
        field(5; "Confirm date"; DateTime)
        {
            Caption = 'Confirm date';
            DataClassification = ToBeClassified;
        }
        field(6; estimated_delivery_date; Date)
        {
            Caption = 'estimated_delivery_date';
            DataClassification = ToBeClassified;
        }
        field(7; confirm_comment; Text[2048])
        {
            Caption = 'confirm_comment';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; RequestCode, "Confirm by")
        {
            Clustered = true;
        }
    }
}
