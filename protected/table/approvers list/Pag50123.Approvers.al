page 50123 Approvers
{
    Caption = 'Approvers';
    PageType = ListPart;
    SourceTable = "Approvers List";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Position; Rec.Position)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Position field.';
                }
                field("User name"; Rec."User name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User name field.';
                }
                field("Full name"; Rec."Full name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full name field.';
                }
            }
        }
    }
}
