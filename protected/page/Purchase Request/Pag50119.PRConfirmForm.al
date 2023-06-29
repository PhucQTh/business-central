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
            field(Comment; Rec.confirm_comment)
            {
                ShowCaption = false;
                ApplicationArea = All;
                MultiLine = true;
            }
            usercontrol(ConfirmButton; Button)
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    CurrPage.ConfirmButton.CreateButton('Confirm', 'btn btn-primary');
                end;

                trigger ButtonAction()
                var
                    status: enum "Confirm Status";
                begin
                    if Rec.confirm_comment <> '' then begin
                        rec.Status := status::Confirmed;
                        CurrPage.Close();
                    end else
                        Message('Please enter comment!');
                end;
            }
        }

    }
    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(0);
    end;


}



