page 50118 Receiver
{
    Caption = 'Receiver';
    PageType = ListPart;
    SourceTable = "Purchase Request Confirm";
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(Status; Rec.Status)
                {
                    ShowCaption = false;
                    Editable = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                }
                field("Confirm by"; Rec."Confirm by")
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirm by field.';
                    TableRelation = User."User Name";
                }
                field("Comment"; Rec.confirm_comment)
                {
                    Editable = false;
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Confirm by field.';
                }
            }
        }
    }
}
