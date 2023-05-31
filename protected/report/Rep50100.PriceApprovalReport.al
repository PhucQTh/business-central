report 50100 "Price Approval Report"
{
    ApplicationArea = All;
    Caption = 'Price Approval Report';
    UsageCategory = ReportsAndAnalysis;
    DefaultLayout = Excel;
    ExcelLayout = './price-approval-report.xlsx';
    dataset
    {
        dataitem(PriceApproval; "Price Approval")
        {
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
    var
        ApprovalStatus: enum "Custom Approval Enum";
}
