report 50100 "Price Approval Report"
{
    ApplicationArea = All;
    Caption = 'Price Approval Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = 'protected/report/price-approval-report.xlsx';
    // UseRequestPage = false;
    PreviewMode = PrintLayout;

    dataset
    {
        dataitem(PriceApproval; "Price Approval")
        {
            RequestFilterFields = "No_", "Title", "Due Date", UserName, Status;
            column(No_; No_)
            {
            }
            column(PRNo; "PR No.")
            {
            }
            column(Title; Title)
            {
            }
            column(DueDate; "Due Date")
            {
            }
            column(UserID; Username)
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }
        }
    }
    requestpage
    {
        ShowFilter = false;
        // SaveValues = true;
        layout
        {
            area(content)
            { }
        }
        actions
        {
            area(Processing)
            {
                action(Execute)
                {

                    Caption = 'Execute';
                    trigger OnAction()
                    begin
                        Message('1');
                    end;
                }
            }
        }


    }
}
