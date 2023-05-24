page 50101 "Price Approvals"
{
    ApplicationArea = All;
    Caption = 'Price Approvals';
    PageType = List;
    SourceTable = "Price Approval";
    CardPageId = "Price Approval";
    UsageCategory = Lists;
    ShowFilter = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No_; Rec.NO_)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Title"; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("User ID"; Rec."User ID")
                {
                    Caption = 'Request by';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request by field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }

                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }

            }
        }
    }
    trigger OnOpenPage()
    var
    begin
        Rec.SetView(StrSubstNo('sorting (Title) order(descending) where ("User ID" = filter (%1))', UserId));
    end;
}


