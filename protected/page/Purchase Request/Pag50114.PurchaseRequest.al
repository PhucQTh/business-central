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
                        if (NOT checkEmptyForm()) then begin
                            Message('You must clear the items form before change.');
                            Good := false;
                            exit;
                        end;
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
                        if (NOT checkEmptyForm()) then begin
                            Message('You must clear the items form before change.');
                            Service := false;
                            exit;
                        end;
                        Rec.pr_type := 2;
                        Good := false;
                        CurrPage.Update();
                    end;
                }
            }
            group("REQUEST INFORMATION")
            {
                Caption = 'General';
                field(Title; Rec.pr_notes)
                {
                    Caption = 'Title';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the DienGiaiChung field.';
                    MultiLine = true;

                }
                field("Request By"; Rec."Request By")
                {
                    Visible = isCurrentUser;
                    Editable = false;
                    Caption = 'Requester Name';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TenBoPhan field.';

                }
                field("Requester Name"; RequesterEmail)
                {
                    Visible = isCurrentUser;
                    Editable = false;
                    Caption = 'Requester Email';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the department_end_user field.';
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
                field("Request date"; Requestdate)
                {
                    Editable = false;
                    ApplicationArea = All;

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
            part(RECEIVER; Receiver)
            {
                Caption = 'RECEIVER';
                ApplicationArea = All;
                SubPageLink = RequestCode = field("NO_");
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
            part(Collaborators; EmailCC)
            {
                Caption = 'Collaborators';
                ApplicationArea = All;
                SubPageLink = ApprovalID = field("NO_");
            }

        }

    }
    actions
    {
        area(Processing)
        {
            action("Receiver Confirm")
            {
                Caption = 'Confirm';
                ApplicationArea = All;
                Image = Completed;
                Promoted = false;
                trigger OnAction()
                var
                    ConfirmPage: Page "PR Confirm Form";
                begin
                    ConfirmPage.RunModal();
                end;

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
        IF Rec."Request By" = UserId then isCurrentUser := true else isCurrentUser := false;
    end;

    procedure checkEmptyForm(): Boolean
    var
        FormItem: Record "Request Purchase Form";
    begin
        FormItem.SetRange(id, Rec.No_);
        If FormItem.FindSet() then exit(false);
        exit(true);
    end;

    var
        Requestdate: Date;
        Good: Boolean;
        Service: Boolean;
        GoodStyle: Text;
        ServiceStyle: Text;
        RequesterEmail: Text;
        isCurrentUser: Boolean;
}
