table 50108 "Purchase Request Form"
{
    DataClassification = ToBeClassified;

    fields
    {
        field(1; title; Text[500])
        {
            Caption = 'title';
            DataClassification = ToBeClassified;
        }
        field(2; description; Text[2048])
        {
            Caption = 'description';
            DataClassification = ToBeClassified;
        }
        field(3; quantity; Decimal)
        {
            Caption = 'quantity';
            DataClassification = ToBeClassified;
        }
        field(4; unit; Text[20])
        {
            Caption = 'unit';
            DataClassification = ToBeClassified;
        }
        field(5; delivery_date; Date)
        {
            Caption = 'delivery_date';
            DataClassification = ToBeClassified;
        }
        field(6; estimated_date; Date)
        {
            Caption = 'estimated_date';
            DataClassification = ToBeClassified;
        }
        field(7; purpose; Text[2048])
        {
            Caption = 'purpose';
            DataClassification = ToBeClassified;
        }
        field(8; remark; Text[2048])
        {
            Caption = 'remark';
            DataClassification = ToBeClassified;
        }
        field(9; request_approval_id; Code[20])
        {
            Caption = 'request_approval_id';
            DataClassification = ToBeClassified;
        }
        field(10; pr_code; Text[50])
        {
            Caption = 'pr_code';
            DataClassification = ToBeClassified;
        }
        field(11; "type"; Integer)
        {
            Caption = 'type';
            DataClassification = ToBeClassified;
        }
        field(12; id; Code[20])
        {
            Caption = 'id';
            DataClassification = ToBeClassified;
        }
        field(13; "Line No."; Integer)
        {
            Caption = 'Line No.';
            AutoIncrement = true;
        }
    }
    keys
    {
        key(PK; id, "Line No.")
        {
            Clustered = true;
        }
    }
}
