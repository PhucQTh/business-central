page 50131 "Test Page Sperate"
{
    Caption = 'Test Page Sperate';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    layout
    {
        area(content)
        {
            part("Open"; "Cylinder Gird")
            {
                Caption = 'Open';
                ApplicationArea = All;
                SubPageLink = "Status" = const(Open);
            }
            part("OnHold"; "Cylinder Gird")
            {
                ApplicationArea = All;
                SubPageLink = "Status" = const(Pending);
            }
            part("Pending"; "Cylinder Gird")
            {
                ApplicationArea = All;
                SubPageLink = "Status" = const(Pending);
            }

            part("Approved"; "Cylinder Gird")
            {
                ApplicationArea = All;
                SubPageLink = "Status" = const(Approved);
            }
            part("Rejected"; "Cylinder Gird")
            {
                ApplicationArea = All;
                SubPageLink = "Status" = const(Rejected);
            }
        }
    }
    var
        ApprovalStatus: Enum "Custom Approval Enum";
}
