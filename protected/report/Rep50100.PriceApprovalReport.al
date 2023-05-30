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
            RequestFilterFields = "No_", "Title", "Due Date", "User ID", Status;
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
            column(UserID; "User ID")
            {
            }
            column(SystemCreatedAt; SystemCreatedAt)
            {
            }

        }
    }
    requestpage
    {
        SaveValues = true;
        layout
        {
            area(content)
            { }
        }

    }
}
