page 50115 "Purchase Form"
{
    Caption = 'Purchase Form';
    PageType = ListPart;
    SourceTable = "Request Purchase Form";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(pr_code; Rec.pr_code)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the pr_code field.';
                }
                field(title; Rec.title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the title field.';
                }
                field(description; Rec.description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the description field.';
                }
                field(quantity; Rec.quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the quantity field.';
                }
                field(unit; Rec.unit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the unit field.';
                }
                field(delivery_date; Rec.delivery_date)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the delivery_date field.';
                }
                field(purpose; Rec.purpose)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the purpose field.';
                }
                field(remark; Rec.remark)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the remark field.';
                }



            }
        }
    }
}
