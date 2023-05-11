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
                field("User ID"; Rec."User ID")
                {
                    Caption = 'Request by';
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
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }
                // field(SystemCreatedBy; Rec.SystemCreatedBy)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the SystemCreatedBy field.';
                // }

                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
                // field(SystemModifiedBy; Rec.SystemModifiedBy)
                // {
                //     ApplicationArea = All;
                //     ToolTip = 'Specifies the value of the SystemModifiedBy field.';
                // }
            }
        }
    }

}
