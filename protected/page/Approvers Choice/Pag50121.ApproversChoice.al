page 50121 ApproversChoice
{
    Caption = 'Workflow User Group Members';
    PageType = ListPart;
    SourceTable = "Approval Workflow User Step";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name"; Rec."User name")
                {
                    ApplicationArea = Suite;
                    LookupPageID = "Approvers List";
                    ToolTip = 'Specifies the name of the workflow user.';
                }
                field("Sequence No."; Rec."Sequence No.")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the order of approvers when an approval workflow involves more than one approver.';
                }
            }
        }
    }

    actions
    {
    }
}
