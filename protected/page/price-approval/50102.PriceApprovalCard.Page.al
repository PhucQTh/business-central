page 50102 "Price Approval"
{
    Caption = 'Price Approval';
    RefreshOnActivate = true;
    PageType = Card;
    SourceTable = "Price Approval";
    PromotedActionCategories = 'Approval';
    // DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group("Title Group")
            {
                Caption = 'Title';
                field("Title"; Rec.Title)
                {
                    ShowCaption = false;
                    Editable = DynamicEditable;
                    ShowMandatory = true;
                    ApplicationArea = All;
                }
            }
            group(Generals)
            {
                Editable = DynamicEditable;

                group(Informations)
                {

                    field("Request By"; Rec."Request By")
                    {
                        Caption = 'Request by';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field("Department"; Rec.Department)
                    {
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(Purpose; Rec.Purpose)
                    {
                        Editable = DynamicEditable;
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                }
                group("Ticket Status")
                {
                    field(Status; Rec.Status)
                    {
                        Editable = false;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Status field.';
                        StyleExpr = StatusStyleTxt;
                    }
                    field("Due Date"; Rec."Due Date")
                    {
                        Editable = DynamicEditable;
                        ShowMandatory = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Due Date field.';
                    }
                }
            }
            //! ----------------------------- Material Render ---------------------------- */
            part(HTMLRender; "Material Html Rendering") //! Standard
            {
                Editable = DynamicEditable;
                Visible = (Rec.ApprovalType = RecordType::Standard);
                ApplicationArea = All;
            }
            part("General Material"; "General Material")//! General
            {
                Editable = DynamicEditable;
                Visible = (Rec.ApprovalType = RecordType::General);
                ApplicationArea = All;
            }
            //! ----------------------------- Material Render ---------------------------- */

            group("General explanation")
            {
                Editable = DynamicEditable;
                Visible = true;
                usercontrol(SMTEditor; "SMT Editor")
                {
                    Visible = DynamicEditable;
                    ApplicationArea = All;
                    trigger ControlAddinReady()
                    begin
                        NewData := Rec.GetContent();
                        CurrPage.SMTEditor.InitializeSummerNote(NewData, 'full');
                    end;

                    trigger onBlur(Data: Text)
                    begin
                        NewData := Data;
                    end;
                }
                usercontrol(htmlShow; HTML)
                {
                    ApplicationArea = All;
                    Visible = NOT DynamicEditable;
                    trigger ControlReady()
                    begin
                        NewData := Rec.GetContent();
                        If (NewData <> '') then
                            CurrPage.htmlShow.Render(NewData, false)
                        else
                            CurrPage.htmlShow.Render('<div class="grid-emptyrowmessage" style="display: block;"><span>(There is nothing to show in this view)</span></div>', false);
                    end;
                }
            }
            part(Collaborators; EmailCC)
            {
                Editable = DynamicEditable;
                Caption = 'Collaborators';
                ApplicationArea = All;
                SubPageLink = ApprovalID = field("NO_");
            }
            part(Approvers; ApproversChoice)
            {
                Editable = DynamicEditable;
                Caption = 'Approvers';
                ApplicationArea = All;
                SubPageLink = RequestId = field("NO_");
            }
            part("Attached Documents List"; "Document Attachment ListPart")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50105),
                              "No." = FIELD(No_);
            }
        }
        area(FactBoxes)
        {
            part("Attached Documents"; "Document Attachment Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50105),
                              "No." = FIELD(No_);
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
                    Visible = OpenApprovalEntriesExistCurrUser AND (Rec.Status <> P::OnHold);
                    trigger OnAction()
                    begin
                        Rec.Status := p::OnHold;
                        Rec.Modify();
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested.';
                    Promoted = true;
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

                    PromotedCategory = New;


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
                    PromotedCategory = Process; //!Show in toolbar
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
                    Visible = NOT OpenApprovalEntriesExist AND ((p::Open = Rec."Status") OR (p::Rejected = Rec."Status")) AND CanRequestApprovalForRecord;//! Could be use Enabled
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Approval Wfl Mgt";
                        RecRef: RecordRef;
                    begin
                        Rec.RequestDate := Today();
                        RecRef.GetTable(Rec);
                        if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then begin
                            CustomWorkflowMgmt.OnSendWorkflowForApproval(RecRef);
                        end;
                        SetEditStatus();
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
            Action(AttachFiles)
            {
                ApplicationArea = All;
                Caption = 'Attach files';
                Image = Attachments;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = DynamicEditable;
                trigger OnAction()
                var
                    Helper: Codeunit Helper;
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    Helper.AttachFile(RecRef);
                end;
            }

        }
    }

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        exit(0);
    end;


    trigger OnOpenPage()
    var
        URL: text;
    begin
        SetEditStatus();
    end;

    trigger OnAfterGetCurrRecord()
    var
        CustomWflMgmt: Codeunit "Approval Wfl Mgt";
        Selected: Integer;
        Text000: Label 'Choose one of the price approval type:';
        Text001: Label 'Standard,General';
    begin
        IF Rec.ApprovalType = RecordType::Initial THEN BEGIN
            Selected := Dialog.StrMenu(Text001, 1, Text000);
            if (Selected = 0) then begin
                Rec.ApprovalType := RecordType::Initial;
                CurrPage.Close();
                EXIT;
            end;
            if Selected = 1 then rec.ApprovalType := RecordType::Standard else Rec.ApprovalType := RecordType::General;
            Rec.Status := p::Open;
            Rec."Request By" := UserId();
            CurrPage.Update(true);
        END;
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        CanRequestApprovalForRecord := CustomWflMgmt.CanRequestApprovalForRecord(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        HasApprovalEntries := ApprovalsMgmt.HasApprovalEntries(Rec.RecordId);
        StatusStyleTxt := CustomWflMgmt.GetStatusStyleText(Rec.Status);
        CurrPage.Update(true);
        CurrPage.HTMLRender.Page.GetData(Rec.No_, DynamicEditable);
    end;


    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        Helper: Codeunit "Helper";
        Result: Boolean;
    begin
        IF isDeleted = TRUE then
            exit(true) ELSE
            IF (Rec.ApprovalType <> RecordType::Initial) then
                if (Rec.Title = '') OR (Rec.Purpose = '') then begin
                    Result := Helper.CloseConfirmDialog('Some important fields are empty. You must complete them in order to save the request? Do you want to close without saving?');
                    if Result = true then begin
                        Rec.Delete();
                        exit(true); //!  Close page  
                    end;
                    exit(false); //! continue page
                end;
        exit(true); //!  Close page 
    end;

    trigger OnClosePage()
    begin
        if (DynamicEditable) then Rec.SetContent(NewData);
        CurrPage.Close();
    end;

    trigger OnDeleteRecord(): Boolean
    var
        MaterialTreeFunctions: Codeunit "MaterialTreeFunction";
    begin
        MaterialTreeFunctions.DeleteMaterialEntries(-1, Rec.No_);
        isDeleted := true;
    end;


    procedure SetEditStatus()
    begin
        CurrPage.Editable(true);
        DynamicEditable := true;
        if (Rec.ApprovalType = RecordType::Initial) then begin
            DynamicEditable := true;
            exit;
        end;
        if (Rec."Request By" <> UserId) OR (Rec."Status" <> p::Open) then
            DynamicEditable := false;
    end;

    var
        RecordType: Enum "Approval Type";
        p: enum "Custom Approval Enum";
        OpenApprovalEntriesExistCurrUser, OpenApprovalEntriesExist, CanCancelApprovalForRecord, CanRequestApprovalForRecord
        , HasApprovalEntries : Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DynamicEditable: Boolean;
        StatusStyleTxt: Text;
        EditorReady: Boolean;
        NewData: Text;
        AddNewBtnLbl: Label 'ADD NEW MATERIAL';
        Comment: Text;
        IsHTMLFormatted: Boolean;

        isDeleted: Boolean;

}
