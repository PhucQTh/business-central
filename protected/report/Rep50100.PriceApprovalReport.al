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
            trigger OnPreDataItem()
            begin
                // SetRange(Number, 1, TopN);
                // TopNcar.TopNumberOfRows(TopN);
                // TopNcar.Open();
            end;

            trigger OnAfterGetRecord()
            begin
                // if (TopNcar.Read())
                // then begin
                //     Car_Code := TopNcar.Car_Code;
                //     Car_Name := TopNcar.Car_Name;
                //     Quantity := TopNcar.Quantity;
                //     Price := TopNcar.Price;
                // end
                // else begin
                //     CurrReport.Skip();
                // end;
            end;
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
