page 50101 "Price Approvals"
{
    ApplicationArea = All;
    Caption = 'Price Approvals';
    PageType = List;
    SourceTable = "Price Approval";
    CardPageId = "Price Approval";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No_; Rec.NO_)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the comment field.';
                }
                field("Title"; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the comment field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }
                field(Status; Rec.Status)
                {
                    ToolTip = 'Specifies the value of the Status field.';
                }
            }
        }
    }

}
