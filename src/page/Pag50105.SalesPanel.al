page 50105 "Sales Panel"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Sales Tree";
    Editable = true;
    ModifyAllowed = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            grid(Mygrid)
            {
                group(OrdersGroup)
                {
                    ShowCaption = false;
                    part(Orders; "Sales Tree Orders")
                    {
                        ApplicationArea = all;
                    }
                }
            }
            grid(Mygrid2)
            {
                group(InvoicesGroup)
                {
                    ShowCaption = false;
                    part(Invoices; "Sales Tree Invoices")
                    {
                        ApplicationArea = all;
                    }

                }
                group(MemosGroup)
                {
                    ShowCaption = false;
                    part(Memos; "Sales Tree Cr. Memos")
                    {
                        ApplicationArea = all;
                    }
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Update)
            {
                ApplicationArea = all;
                Image = WorkCenterLoad;
                Caption = 'Update Panel';

                trigger OnAction()
                var
                    UpdatedLbl: Label 'Panel updated';
                begin
                    CurrPage.Orders.Page.LoadOrders();
                    CurrPage.Invoices.Page.LoadInvoices();
                    CurrPage.Memos.Page.LoadMemos();
                    Message(UpdatedLbl);
                end;
            }
        }
    }
}