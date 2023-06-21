page 50104 "No. Series Assignment"
{
    ApplicationArea = Basic, Suite;
    Caption = 'No. Series Assignment';
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
                field("Price Approval No."; Rec."Price Approval No.")
                {
                    ApplicationArea = All;

                }
                field("Purchase Request No."; Rec."Purchase Request No.")
                {
                    Caption = 'Purchase Request No.';
                    ApplicationArea = All;

                }
            }
        }
    }


    //! Trigger to create item when open this page in the first time
    trigger OnOpenPage()
    var
        NoseriesSetup: Record "No. Series Setup"; //! define record

    begin
        NoseriesSetup.INIT; //! init record
        if NoseriesSetup.IsEmpty() then
            NoseriesSetup.INSERT();
    end;
}
