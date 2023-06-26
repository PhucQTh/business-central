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
            // group(General)
            // {
            //     Caption = 'General';
            //     field(confirm_comment; Rec.confirm_comment)
            //     {
            //         Caption = 'Comment';
            //         ApplicationArea = All;
            //         MultiLine = true;
            //     }

            // }
            usercontrol(SMTEditor; "SMT Editor")
            {
                ApplicationArea = All;
                trigger ControlAddinReady()
                begin
                    // NewData := Rec.GetContent();
                    CurrPage.SMTEditor.InitializeSummerNote(Rec.confirm_comment, 'compact');
                end;

                trigger onBlur(Data: Text)
                begin
                    Rec.confirm_comment := Data;
                end;
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



}



