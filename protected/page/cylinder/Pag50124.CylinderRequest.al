page 50124 "Cylinder Request"
{
    Caption = 'Cylinder Request';
    PageType = List;
    SourceTable = "cylinder info";
    CardPageId = 50125;
    ApplicationArea = All;
    UsageCategory = Documents;
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No_")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(QCSP; Rec.QCSP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QCSP field.';
                }
                field(product_name; Rec.product_name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the product_name field.';
                }
            }
        }
    }
}
