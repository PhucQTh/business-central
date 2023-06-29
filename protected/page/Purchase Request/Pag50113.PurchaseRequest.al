page 50113 "Purchase Request"
{
    ApplicationArea = All;
    Caption = 'Purchase Request';
    PageType = List;
    SourceTable = "Purchase Request Info";
    UsageCategory = Lists;
    CardPageId = 50114;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No_; Rec.No_)
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the id field.';
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = StatusStyleTxt;
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the id field.';
                }

                field(pr_notes; Rec.pr_notes)
                {
                    Caption = 'Purpose';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the pr_notes field.';
                }
                field(TenBoPhan; Rec.TenBoPhan)
                {
                    Caption = 'Department';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TenBoPhan field.';
                }

                field("Request By"; Rec."Request By")
                {
                    Caption = 'Request By';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NguoiYeuCau field.';
                }

            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Reset Filter")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = RemoveFilterLines;

                trigger OnAction()
                begin
                    Rec.SetFilter(Rec.No_, '');
                    Rec.SetFilter(Rec.pr_notes, '');
                    Rec.SetFilter(Rec."Request By", '');
                    CurrPage.Update();
                end;
            }
        }
    }
    trigger OnAfterGetRecord()
    var
        CustomWflMgmt: Codeunit "Approval Wfl Mgt";
    begin
        StatusStyleTxt := CustomWflMgmt.GetStatusStyleText(Rec.Status);
    end;

    var
        StatusStyleTxt: Text;
}
