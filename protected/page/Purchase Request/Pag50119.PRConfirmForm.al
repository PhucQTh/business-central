page 50119 "PR Confirm Form"
{
    Caption = 'PR Confirm Form';
    PageType = Card;
    SourceTable = "Purchase Request Confirm";
    DeleteAllowed = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(confirm_comment; Rec.confirm_comment)
                {
                    Caption = 'Comment';
                    ApplicationArea = All;
                    MultiLine = true;
                }

            }
            field("Confirm by"; 'Confirm')
            {
                ApplicationArea = All;
                ShowCaption = false;
                trigger OnDrillDown()
                begin
                    Message('OK');
                end;
            }
        }
    }



}



