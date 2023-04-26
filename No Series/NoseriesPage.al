page 50104 "No. Series Setup"
{
    ApplicationArea = Basic, Suite;
    Caption = 'No. Series Setup';
    DataCaptionExpression = '';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "No. Series Setup";
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            group(Settings)
            {
                field("Test Item No."; Rec."Test No.")
                {
                    ApplicationArea = All;

                }

            }
        }
    }

    trigger OnOpenPage()
    var
        NoseriesSetup: Record "No. Series Setup";

    begin
        NoseriesSetup.INIT;
        if NoseriesSetup.IsEmpty() then
            NoseriesSetup.INSERT();
    end;
}
