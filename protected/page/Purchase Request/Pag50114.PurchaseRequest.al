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
                field(Title; Rec.pr_notes)
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
                    SubPageLink = id = field(No_), type = field(pr_type);
                }
                part("Services"; "Services Form")
                {
                    Visible = Service;
                    Caption = 'Services';
                    ApplicationArea = All;
                    SubPageLink = id = field(No_), type = field(pr_type);
                }
            }
            part(Collaborators; EmailCC)
            {
                Caption = 'Collaborators';
                ApplicationArea = All;
                SubPageLink = ApprovalID = field("NO_");
            }
            field(Attachments; 'Add Attachment')
            {
                ApplicationArea = All;
                ShowCaption = false;
                StyleExpr = 'Favorable';
                Caption = 'Attach files';
                trigger OnDrillDown()
                var
                    DocumentAttachmentDetails: Page "Document Attachment Details";
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    DocumentAttachmentDetails.OpenForRecRef(RecRef);
                    DocumentAttachmentDetails.RunModal();
                end;
            }
            part("Attached Documents List"; "Document Attachment ListPart")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50109),
                              "No." = FIELD(No_);
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Good := true;
        Service := false;
        Rec.pr_type := 1;
        Rec."Request By" := UserId;
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
