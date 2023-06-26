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
            part("PU Department"; "PU Department")
            {
                ApplicationArea = All;
                Editable = false;
            }
            part(RECEIVER; Receiver)
            {
                Caption = 'RECEIVER';
                ApplicationArea = All;
                SubPageLink = RequestCode = field("NO_");
            }
            usercontrol("Attach management"; Button)
            {
                ApplicationArea = All;
                trigger ControlReady()
                begin
                    CurrPage."Attach management".CreateButton('Attach management', 'btn btn-primary my-2');
                end;

                trigger ButtonAction()
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
            group(Approval)
            {
                Image = Approvals;
                action(onHold)
                {
                    Caption = 'On Hold';
                    ApplicationArea = All;
                    Image = Answers;
                    Promoted = false;
                    // Visible = OpenApprovalEntriesExistCurrUser AND (Rec.Status <> P::OnHold);
                    trigger OnAction()
                    begin
                        // Rec.Status := p::OnHold;
                        Rec.Modify();
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested.';
                    Promoted = false;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    trigger OnAction()
                    var
                        Question: Text;
                        Answer: Boolean;
                        Text000: Label 'Do you agree with this request?';
                    begin
                        Question := Text000;
                        Answer := Dialog.Confirm(Question, true, false);
                        if Answer = true then begin
                            ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        end;
                    end;

                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistCurrUser;
                    Promoted = false;
                    trigger OnAction()
                    var
                        Question: Text;
                        Answer: Boolean;
                        Text000: Label 'Reject request?';
                    begin
                        Question := Text000;
                        Answer := Dialog.Confirm(Question, true, false);
                        if Answer = true then begin
                            ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        end;
                    end;

                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistCurrUser;
                    Promoted = false;
                    trigger OnAction()

                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistCurrUser;
                    Promoted = false;


                    trigger OnAction()
                    begin
                        // ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals History';
                    Image = Approvals;
                    ToolTip = 'View approval requests.';
                    Promoted = false;
                    Visible = HasApprovalEntries;

                    trigger OnAction()
                    begin
                        // ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }

            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    // Visible = NOT OpenApprovalEntriesExist AND ((p::Open = Rec."Status") OR (p::Rejected = Rec."Status")) AND CanRequestApprovalForRecord;//! Could be use Enabled
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';
                    Promoted = false;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Approval Wfl Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then
                            CustomWorkflowMgmt.OnSendWorkflowForApproval(RecRef);
                        // SetEditStatus();
                        CurrPage.Update(false);
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Visible = CanCancelApprovalForRecord; //! Could be use Enabled
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';
                    Promoted = false;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Approval Wfl Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        CustomWorkflowMgmt.OnCancelWorkflowForApproval(RecRef);
                        // SetEditStatus();
                    end;
                }
            }

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
        OpenApprovalEntriesExistCurrUser, OpenApprovalEntriesExist, CanCancelApprovalForRecord, CanRequestApprovalForRecord
        , HasApprovalEntries : Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";


}
