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
                Visible = DynamicEditable;
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
                Editable = DynamicEditable;
                field(Title; Rec.pr_notes)
                {
                    Caption = 'Title';
                    ApplicationArea = All;
                    MultiLine = true;

                }
                field(Status; Rec.Status)
                {
                    Caption = 'Status';
                    ApplicationArea = All;
                    StyleExpr = StatusStyleTxt;
                    Editable = false;
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
                field("Request date"; Rec.RequestDate)
                {
                    Editable = false;
                    ApplicationArea = All;
                }


            }

            group(Form)
            {
                Editable = DynamicEditable;
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
                Caption = '';
                Visible = isCurrentUser;
                ApplicationArea = All;
                Editable = false;
            }
            part(RECEIVER; Receiver)
            {
                Editable = DynamicEditable;

                Caption = 'RECEIVER';
                ApplicationArea = All;
                SubPageLink = RequestCode = field("NO_");
            }
            usercontrol("Attach management"; Button)
            {
                ApplicationArea = All;
                Visible = DynamicEditable;
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
                Editable = DynamicEditable;
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
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistCurrUser AND (Rec.Status <> P::OnHold);
                    trigger OnAction()
                    var
                        Response: Codeunit MyWorkflowResponses;
                    begin
                        Rec.Status := p::OnHold;
                        Rec.Modify();
                        Response.SentOnHoldEmail(UserId, Rec.RecordId);
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
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
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
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
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
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
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals History';
                    Image = Approvals;
                    ToolTip = 'View approval requests.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Visible = HasApprovalEntries;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
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
                    Visible = NOT OpenApprovalEntriesExist AND (p::Open = Rec."Status") AND isCurrentUser;//! Could be use Enabled
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Approval Wfl Mgt";
                        RecRef: RecordRef;
                    begin
                        Rec.RequestDate := Today();
                        RecRef.GetTable(Rec);
                        if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then begin
                            IF CanRequestApprovalForRecord then begin
                                CustomWorkflowMgmt.OnSendWorkflowForApproval(RecRef);
                                SetEditStatus();
                            end;
                        end;

                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Visible = CanCancelApprovalForRecord; //! Could be use Enabled
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Approval Wfl Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        CustomWorkflowMgmt.OnCancelWorkflowForApproval(RecRef);
                        SetEditStatus();
                    end;
                }
            }

            action("Receiver Confirm")
            {
                Caption = 'Confirm';
                ApplicationArea = All;
                Image = Completed;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;

                Visible = (Rec.Status = p::Approved) AND isReceiver;
                trigger OnAction()
                var
                    ConfirmPage: Page "PR Confirm Form";
                    Receiver: Record "Purchase Request Confirm";

                begin
                    Receiver.SetRange(RequestCode, Rec.No_);
                    Receiver.SetRange("Confirm by", UserId());
                    Receiver.FindSet();
                    ConfirmPage.SetRecord(Receiver);
                    ConfirmPage.RunModal();
                end;

            }

            action(Comments)
            {
                Enabled = HasApprovalEntries;
                ApplicationArea = Suite;
                Caption = 'Comments';
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Image = ViewComments;
                ToolTip = 'View or add comments for the record.';

                trigger OnAction()
                var
                    ApprovalsMgmt: Codeunit "Approvals Mgmt.";
                    RecRef: RecordRef;
                begin
                    RecRef.Get(Rec.RecordId);
                    Clear(ApprovalsMgmt);
                    ApprovalsMgmt.GetApprovalComment(RecRef);
                end;
            }


        }
    }

    procedure SetEditStatus()
    begin
        CurrPage.Editable(true);
        DynamicEditable := true;
        if (Rec.SystemCreatedBy <> UserSecurityId())
        then
            isCurrentUser := false else
            isCurrentUser := true;
        if (Rec.SystemCreatedBy <> UserSecurityId()) OR (Rec."Status" <> p::Open) then
            DynamicEditable := false;
    end;

    // trigger OnNewRecord(BelowxRec: Boolean)
    // begin
    //     Good := true;
    //     Service := false;
    //     Rec.pr_type := 1;
    //     Rec."Request By" := UserId;
    // end;

    trigger OnAfterGetCurrRecord()
    var
        CustomWflMgmt: Codeunit "Approval Wfl Mgt";
    begin
        if (Rec.No_ = '') then begin //AND (Rec."Request By" = UserId) then begin

            Rec.pr_type := 1;
            Rec."Request By" := UserId;
            CurrPage.Editable(true);
            DynamicEditable := true;
        end;
        if Rec.pr_notes <> '' then SetEditStatus();
        IF Rec.pr_type = 1 then Good := true else Service := true;
        IF Rec."Request By" = UserId then isCurrentUser := true else isCurrentUser := false;
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        CanRequestApprovalForRecord := CustomWflMgmt.CanRequestApprovalForRecord(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        HasApprovalEntries := ApprovalsMgmt.HasApprovalEntries(Rec.RecordId);
        StatusStyleTxt := CustomWflMgmt.GetStatusStyleText(Rec.Status);
        checkIsReceiver();
        CurrPage.Update(true);
    end;

    trigger OnOpenPage()
    begin
        SetEditStatus();
    end;

    procedure checkEmptyForm(): Boolean
    var
        FormItem: Record "Purchase Request Form";
    begin
        FormItem.SetRange(id, Rec.No_);
        If FormItem.FindSet() then exit(false);
        exit(true);
    end;

    procedure checkIsReceiver(): Boolean
    var
        Receiver: Record "Purchase Request Confirm";
        status: Enum "Confirm Status";
    begin
        Receiver.SetRange(RequestCode, Rec.No_);
        Receiver.SetRange("Confirm by", UserId());
        Receiver.SetRange(Status, status::Pending);
        If Receiver.FindSet() then isReceiver := true else isReceiver := false;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Helper: Codeunit "Helper";
        Result: Boolean;
    begin
        if Rec.pr_notes = '' then
            Result := Helper.CloseConfirmDialog('You must fill in the title to save the record! Do you want to close without saving?')
        else
            exit(true);
        //* This code is check if the user want to close without saving
        if Result = true then begin
            Rec.Delete();
            CurrPage.Close();
            exit(true); //!  Close page  
        end else
            exit(false);//! continue page   
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(0);
    end;



    var
        isReceiver: Boolean;
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
        StatusStyleTxt: Text;
        DynamicEditable: Boolean;

        p: enum "Custom Approval Enum";

}
