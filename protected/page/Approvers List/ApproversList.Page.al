page 50122 "Approvers List"
{
    ApplicationArea = All;
    Caption = 'Approvers List';
    PageType = List;
    SourceTable = "Approvers List";
    UsageCategory = Administration;

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
                    TableRelation = "User Setup"."User ID";
                }
                field("Full name"; Rec."Full name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Full name field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
            }
        }
    }
}
