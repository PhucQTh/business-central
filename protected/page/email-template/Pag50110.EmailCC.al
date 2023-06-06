page 50110 EmailCC
{
    Caption = 'Collaborators';
    PageType = ListPart;
    SourceTable = "Email CC";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("User Name"; Rec.UserName)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the User field.';
                    TableRelation = User."User Name";
                    // trigger OnLookup(var Text: Text): Boolean
                    // var
                    //     UserList: Page "User Lookup";
                    // begin
                    //     UserList.LookupMode(true);
                    //     if UserList.RunModal() = Action::LookupOK then begin

                    //     end;
                    // end;
                }
                field(Email; Rec.Email)
                {
                    ApplicationArea = All;
                    TableRelation = User."Contact Email";
                    Editable = false;
                }
                field("Full Name"; Rec."Full name")
                {
                    ApplicationArea = All;
                    TableRelation = User."Full Name";
                    Editable = false;
                }
            }
        }
    }

}