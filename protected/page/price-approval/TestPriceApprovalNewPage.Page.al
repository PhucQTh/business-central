page 50133 "Test Price Approval New Page"
{
    Caption = 'Test Price Approval New Page';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            Part(Open; "Price Approval Gird")
            {
                Caption = 'Open';
                ApplicationArea = All;
                SubPageLink = "Status" = const(Open);
            }
            Part(Rejected; "Price Approval Gird")
            {
                Caption = 'Rejected';
                ApplicationArea = All;
                SubPageLink = "Status" = const(Rejected);
            }
        }
    }
}
