pageextension 50100 "User Setup Extend" extends "User Setup"
{
    layout
    {
        addafter("Allow Posting To")
        {
            field("Allow viewing all price approval"; Rec."Allow view price approval")
            {
                ApplicationArea = All;
            }
        }
    }
}
