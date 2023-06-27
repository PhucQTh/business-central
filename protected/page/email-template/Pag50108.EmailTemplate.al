page 50108 "Email Template"
{
    Caption = 'Email Template';
    PageType = Card;
    SourceTable = "Email Template";
    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Name field.';
                }
            }
            field(Subject; Rec.Subject)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the value of the Name field.';
                MultiLine = true;
            }
            group("Body")
            {
                ShowCaption = false;
                Caption = ' ';
                Visible = true;
                usercontrol(SMTEditor; "SMT Editor")
                {
                    ApplicationArea = All;
                    trigger ControlAddinReady()
                    begin
                        NewData := Rec.GetContent();
                        CurrPage.SMTEditor.InitializeSummerNote(NewData, 'full');
                    end;

                    trigger onBlur(Data: Text)
                    begin
                        NewData := Data;
                    end;
                }

            }

        }
    }
    trigger OnClosePage()
    begin
        Rec.SetContent(NewData);
    end;

    var
        NewData: Text;
}
