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
                field(NguoiYeuCau; Rec.NguoiYeuCau)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NguoiYeuCau field.';
                }
                field(TenBoPhan; Rec.TenBoPhan)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TenBoPhan field.';
                }
                field(id; Rec.No_)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the id field.';
                }
                field(pr_notes; Rec.pr_notes)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the pr_notes field.';
                }
                field(pr_number; Rec.pr_number)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the pr_number field.';
                }
            }
        }
    }
}
