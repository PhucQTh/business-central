page 50121 ApproversChoice
{
    Caption = 'Workflow User Group Members';
    PageType = ListPart;
    SourceTable = "Approvers";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("User Name"; Rec.Approver)
                {
                    ApplicationArea = Suite;
                    LookupPageID = "Approval User Setup";
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
