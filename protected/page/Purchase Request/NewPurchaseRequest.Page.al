page 50135 "New Purchase Request"
{
    Caption = 'New Purchase Request';
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Documents;
    Editable = false;
    InsertAllowed = false;

    layout
    {
        area(content)
        {
            part("Open"; "Purchase Request Gird")
            {
                Caption = 'Open';
                ApplicationArea = All;
                SubPageLink = "Status" = const(Open);
            }
            part("OnHold"; "Purchase Request Gird")
            {
                Caption = 'OnHold';
                ApplicationArea = All;
                SubPageLink = "Status" = const(OnHold);
            }
            part("Pending"; "Purchase Request Gird")
            {
                Caption = 'Pending';
                ApplicationArea = All;
                SubPageLink = "Status" = const(Pending);
            }
            part("Approved"; "Purchase Request Gird")
            {
                Caption = 'Approved';
                ApplicationArea = All;
                SubPageLink = "Status" = const(Approved);
            }
            part("Rejected"; "Purchase Request Gird")
            {
                Caption = 'Rejected';
                ApplicationArea = All;
                SubPageLink = "Status" = const(Rejected);
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action(New)
            {
                Caption = 'Create new request';
                ApplicationArea = All;
                Image = Add;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Promoted = true;
                trigger OnAction()
                var
                    PurchaseInfo: Record "Purchase Request Info";
                    PurchasePage: Page "Purchase Request Card";
                begin
                    PurchaseInfo.Init();
                    // PurchaseInfo.No_ := '';
                    // PurchaseInfo.pr_type := 1;
                    // PurchaseInfo."Request By" := UserId;
                    PurchaseInfo.Insert();
                    PurchasePage.SetRecord(PurchaseInfo);
                    PurchasePage.Run();
                end;
            }
        }
    }
}
