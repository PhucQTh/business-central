page 50102 "Price Approval"
{
    ApplicationArea = All;
    Caption = 'Price Approval';
    PageType = Card;
    SourceTable = "Price Approval";
    PromotedActionCategories = 'Approval';
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Generals)
            {
                group(Informations)
                {
                    field("Title"; Rec.Title)
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the comment field.';
                    }

                    field("User ID"; Rec.UserName)
                    {
                        Editable = false;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the comment field.';
                    }

                    field(Purpose; Rec.Purpose)
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Purpose field.';
                    }
                }
                group("Ticket Status")
                {
                    field(Status; Rec.Status)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Status field.';
                    }
                    field("Due Date"; Rec."Due Date")
                    {
                        ShowMandatory = true;
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the Due Date field.';
                    }
                }
            }

            part(HTMLRender; "Material Html Rendering")
            {
                Visible = NOT Rec.ApprovalType;
                ApplicationArea = All;
            }
            part("General Material"; "General Material")
            {
                Visible = Rec.ApprovalType;
                ApplicationArea = All;
            }
            group("General explanation")
            {
                ShowCaption = false;
                Caption = ' ';
                Visible = true;
                usercontrol(SMTEditor; "SMT Editor")
                {
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

            }
            group("Attachment")
            {
                field(Attachments; 'Attachments')
                {
                    ApplicationArea = All;
                    ShowCaption = false;
                    StyleExpr = 'Strong';

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
                    Visible = NOT OpenApprovalEntriesExist AND (p::Open = Rec."Status") OR (p::Rejected = Rec."Status");//! Could be use Enabled
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';
                    Promoted = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Custom Workflow Mgmt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then
                            CustomWorkflowMgmt.OnSendWorkflowForApproval(RecRef);
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
                        CustomWorkflowMgmt: Codeunit "Custom Workflow Mgmt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        CustomWorkflowMgmt.OnCancelWorkflowForApproval(RecRef);
                    end;
                }
                action(Attachmentss)
                {
                    ApplicationArea = All;
                    Caption = 'Attachments';
                    Image = Attach;
                    Promoted = true;
                    ToolTip = 'Add a file as an attachment. You can attach images as well as documents.';

                    trigger OnAction()
                    var
                        DocumentAttachmentDetails: Page "Document Attachment Details";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        DocumentAttachmentDetails.OpenForRecRef(RecRef);
                        DocumentAttachmentDetails.RunModal();
                    end;
                }
            }
        }

    }

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        Message('Function is diabled');
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.UserName := Database.UserId();
    end;

    trigger OnAfterGetCurrRecord()
    var
        Question: Text;
        Selected: Integer;
        Text000: Label 'Choose one of the price approval type:';
        Text001: Label 'Standard,General';
    begin
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        HasApprovalEntries := ApprovalsMgmt.HasApprovalEntries(Rec.RecordId);
        if (Rec.No_ = '') then begin
            Selected := Dialog.StrMenu(Text001, 1, Text000);
            if Selected = 1 then rec.ApprovalType := false else Rec.ApprovalType := true;
            CurrPage.Update();
        end;
        CurrPage.HTMLRender.Page.SetData(Rec.No_);
    end;

    trigger OnDeleteRecord(): Boolean
    var
        MaterialTreeFunctions: Codeunit "MaterialTreeFunction";
    begin
        MaterialTreeFunctions.DeleteMaterialEntries(-1, Rec.No_);
    end;

    trigger OnClosePage()
    begin
        Rec.TestField(Title);
        Rec.TestField("Due Date");
        Rec.TestField(Purpose);
        Rec.SetContent(NewData);
    end;

    trigger OnOpenPage()

    begin
        if (Rec.UserName <> UserId) and (p::Open <> Rec."Status") and (p::Rejected <> Rec."Status") then
            CurrPage.Editable(false);

    end;

    var
        p: enum "Custom Approval Enum";
        OpenApprovalEntriesExistCurrUser, OpenApprovalEntriesExist, CanCancelApprovalForRecord
        , HasApprovalEntries : Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DynamicEditable: Boolean;
        StatusStyleTxt: Text;
        EditorReady: Boolean;
        NewData: Text;
        AddNewBtnLbl: Label 'ADD NEW MATERIAL';
        Comment: Text;
        IsHTMLFormatted: Boolean;

}
