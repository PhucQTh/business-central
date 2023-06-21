page 50114 "Purchase Request Card"
{
    Caption = 'Purchase Request';
    PageType = Card;
    SourceTable = "Purchase Request Info";

    layout
    {
        area(content)
        {
            group("GENERAL INFORMATION")
            {
                field(Good; Good)
                {
                    Editable = NOT Good;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.pr_type := 1;
                        Service := false;
                        CurrPage.Update();
                    end;
                }

                field(Service; Service)
                {
                    Editable = NOT Service;
                    ApplicationArea = All;
                    trigger OnValidate()
                    begin
                        Rec.pr_type := 2;
                        Good := false;
                        CurrPage.Update();
                    end;
                }
            }
            group("REQUEST INFORMATION")
            {
                Caption = 'General';
                field(NguoiYeuCau; Rec.NguoiYeuCau)
                {
                    // ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NguoiYeuCau field.';
                }
                field(Department; Rec.TenBoPhan)
                {
                    Editable = false;
                    Caption = 'Department';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TenBoPhan field.';
                }
                field("End User"; Rec.department_end_user)
                {
                    Caption = 'End User';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the department_end_user field.';
                }
                field(Title; Rec.DienGiaiChung)
                {
                    Caption = 'Title';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DienGiaiChung field.';
                }


            }
            group(Form)
            {
                ShowCaption = false;
                part("Materials"; "Materials Form")
                {
                    Caption = 'Materials';
                    ApplicationArea = All;
                    Visible = Good;
                }
                part("Services"; "Services Form")
                {
                    Visible = Service;
                    Caption = 'Services';
                    ApplicationArea = All;
                }
            }
        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Good := true;
        Service := false;
        Rec.pr_type := 1;
        CurrPage.Update();
    end;

    trigger OnAfterGetCurrRecord()
    begin
        IF Rec.pr_type = 1 then Good := true else Service := true;
        CurrPage.Update();
    end;

    var
        Good: Boolean;
        Service: Boolean;
        GoodStyle: Text;
        ServiceStyle: Text;
}
