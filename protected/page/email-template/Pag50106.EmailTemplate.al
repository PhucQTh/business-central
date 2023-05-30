page 50106 "Email Templates"
{
    Caption = 'Email Template';
    PageType = List;
    SourceTable = "Email Template";
    ApplicationArea = All;
    UsageCategory = Lists;
    CardPageId = "Email Template";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }

            }
        }
    }
}
