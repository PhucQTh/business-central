page 50109 "General Material"
{
    Caption = 'General Material';
    PageType = ListPart;
    SourceTable = Material;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Supplier; Rec.Supplier)
                {
                    Caption = 'Supplier name:';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supplier field.';
                }
                field(Price; Rec.Price)
                {
                    Caption = 'Price/ sellected items:';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Price Term"; Rec."Price Term")
                {
                    Caption = 'Reason:';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Term field.';
                }
                field(Delivery; Rec.Delivery)
                {
                    Caption = 'Delivery:';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery field.';
                }
                field("Payment term"; Rec."Payment term")
                {
                    Caption = 'Payment:';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment term field.';
                }
            }
        }
    }
}
