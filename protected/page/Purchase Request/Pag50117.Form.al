page 50117 Form
{
    ApplicationArea = All;
    UsageCategory = Lists;
    Caption = 'Form AA';
    PageType = List;
    SourceTable = "Request Purchase Form";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Line No."; Rec."Line No.")
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemCreatedBy; Rec.SystemCreatedBy)
                {
                    ApplicationArea = All;
                }
                field(SystemId; Rec.SystemId)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                }
                field(SystemModifiedBy; Rec.SystemModifiedBy)
                {
                    ApplicationArea = All;
                }
                field(delivery_date; Rec.delivery_date)
                {
                    ApplicationArea = All;
                }
                field(description; Rec.description)
                {
                    ApplicationArea = All;
                }
                field(estimated_date; Rec.estimated_date)
                {
                    ApplicationArea = All;
                }
                field(id; Rec.id)
                {
                    ApplicationArea = All;
                }
                field(pr_code; Rec.pr_code)
                {
                    ApplicationArea = All;
                }
                field(purpose; Rec.purpose)
                {
                    ApplicationArea = All;
                }
                field(quantity; Rec.quantity)
                {
                    ApplicationArea = All;
                }
                field(remark; Rec.remark)
                {
                    ApplicationArea = All;
                }
                field(request_approval_id; Rec.request_approval_id)
                {
                    ApplicationArea = All;
                }
                field(title; Rec.title)
                {
                    ApplicationArea = All;
                }
                field("type"; Rec."type")
                {
                    ApplicationArea = All;
                }
                field(unit; Rec.unit)
                {
                    ApplicationArea = All;
                }
            }
        }
    }
}
