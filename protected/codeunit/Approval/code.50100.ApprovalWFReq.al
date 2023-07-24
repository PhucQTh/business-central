codeunit 50100 "Approval Wfl Mgt"
{
    //! ------------------- Check Approvals Workflow Enabled ? ------------------- */
    procedure CheckApprovalsWorkflowEnabled(var RecRef: RecordRef): Boolean
    begin
        if not WorkflowMgt.CanExecuteWorkflow(RecRef, GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef)) then
            Error(NoWorkflowEnabledErr);
        exit(true);
    end;

    procedure GetWorkflowCode(WorkflowCode: code[128]; RecRef: RecordRef): Code[128]
    begin
        exit(DelChr(StrSubstNo(WorkflowCode, RecRef.Name), '=', ' '));
    end;

    procedure HasApprovalEntriesForCurrentUser(RecordID: RecordID): Boolean
    //!Check if there are any approval entries for the current user
    var
        ApprovalEntry: Record "Approval Entry";
    begin
        ApprovalEntry.SetRange("Table ID", RecordID.TableNo);
        ApprovalEntry.SetRange("Record ID to Approve", RecordID);
        // ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Approver ID", UserId);
        // Initial check before performing an expensive query due to the "Related to Change" flow field.
        if ApprovalEntry.IsEmpty() then
            exit(false);
        ApprovalEntry.SetRange("Related to Change", false);

        exit(not ApprovalEntry.IsEmpty());
    end;

    procedure CanRequestApprovalForRecord(RecId: RecordId): Boolean
    var
        RecRef: RecordRef;
        PriceApproval: Record "Price Approval";
        MaterialRec: Record "Material";
        PruchReqInfo: Record "Purchase Request Info";
        PurchReqForm: Record "Purchase Request Form";
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    RecRef.SetTable(PriceApproval);
                    MaterialRec.SetRange("Code", PriceApproval.No_);
                    if MaterialRec.FindSet() then
                        exit(true);
                    exit(false);
                end;
        end;
        case RecRef.Number of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PruchReqInfo);
                    PurchReqForm.SetRange("id", PruchReqInfo.No_);
                    if PurchReqForm.FindSet() then
                        exit(true);
                    exit(false);
                end;
        end;
    end;

    [IntegrationEvent(false, false)]
    procedure OnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    [IntegrationEvent(false, false)]
    procedure OnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
    end;

    //! Add events to the library

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Event Handling", 'OnAddWorkflowEventsToLibrary', '', false, false)]

    //! -------------------- On Add Workflow Events To Library ------------------- */
    local procedure OnAddWorkflowEventsToLibrary()
    var
        RecRef: RecordRef;
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        //** PRICE APPROVAL */
        RecRef.Open(Database::"Price Approval");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Price Approval",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Price Approval",
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);
        RecRef.Close();
        //** PURCHASE REQUEST */
        RecRef.Open(Database::"Purchase Request Info");
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), Database::"Purchase Request Info",
          GetWorkflowEventDesc(WorkflowSendForApprovalEventDescTxt, RecRef), 0, false);
        WorkflowEventHandling.AddEventToLibrary(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), DATABASE::"Purchase Request Info",
          GetWorkflowEventDesc(WorkflowCancelForApprovalEventDescTxt, RecRef), 0, false);
    end;
    //! -------------------------------------------------------------------------- */
    //! -------------------------------- Subscribe ------------------------------- */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Wfl Mgt", 'OnSendWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnSendWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONSENDFORAPPROVALCODE, RecRef), RecRef);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approval Wfl Mgt", 'OnCancelWorkflowForApproval', '', false, false)]
    local procedure RunWorkflowOnCancelWorkflowForApproval(var RecRef: RecordRef)
    begin
        WorkflowMgt.HandleEvent(GetWorkflowCode(RUNWORKFLOWONCANCELFORAPPROVALCODE, RecRef), RecRef);
    end;

    procedure GetWorkflowEventDesc(WorkflowEventDesc: Text; RecRef: RecordRef): Text
    begin
        exit(StrSubstNo(WorkflowEventDesc, RecRef.Name));
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnOpenDocument', '', false, false)]
    local procedure OnOpenDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PriceApprovalRec: Record "Price Approval";
        PurchaseRequestInfoRec: Record "Purchase Request Info";
        ApprovalStatus: Enum "Custom Approval Enum";
    begin
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    RecRef.SetTable(PriceApprovalRec);
                    PriceApprovalRec.Validate(Status, ApprovalStatus::Open);
                    PriceApprovalRec.Modify(true);
                    Handled := true;
                end;

        end;
        case RecRef.Number of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequestInfoRec);
                    PurchaseRequestInfoRec.Validate(Status, ApprovalStatus::Open);
                    PurchaseRequestInfoRec.Modify(true);
                    Handled := true;
                end;

        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnSetStatusToPendingApproval', '', false, false)]
    local procedure OnSetStatusToPendingApproval(RecRef: RecordRef; var Variant: Variant; var IsHandled: Boolean)
    var
        PriceApproval: Record "Price Approval";
        PurchaseRequestInfo: Record "Purchase Request Info";
    begin
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    RecRef.SetTable(PriceApproval);
                    PriceApproval.Validate(Status, PriceApproval.Status::Pending);
                    PriceApproval.Modify(true);
                    Variant := PriceApproval;
                    IsHandled := true;
                end;
        end;
        case RecRef.Number of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequestInfo);
                    PurchaseRequestInfo.Validate(Status, PurchaseRequestInfo.Status::Pending);
                    PurchaseRequestInfo.Modify(true);
                    Variant := PurchaseRequestInfo;
                    IsHandled := true;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnPopulateApprovalEntryArgument', '', false, false)]
    local procedure OnPopulateApprovalEntryArgument(var RecRef: RecordRef; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        PriceApproval: Record "Price Approval";
        PurchaseRequestInfo: Record "Purchase Request Info";
    begin
        case RecRef.Number of
            DataBase::"Price Approval":
                begin
                    RecRef.SetTable(PriceApproval);
                    ApprovalEntryArgument."Document No." := PriceApproval."No_";
                end;
        end;
        case RecRef.Number of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequestInfo);
                    ApprovalEntryArgument."Document No." := PurchaseRequestInfo."No_";
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Approvals Mgmt.", 'OnRejectApprovalRequest', '', false, false)]
    local procedure OnRejectApprovalRequest(var ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        PriceApproval: Record "Price Approval";
        PurchaseRequestInfo: Record "Purchase Request Info";
        v: Codeunit "Record Restriction Mgt.";
    begin
        case ApprovalEntry."Table ID" of
            DataBase::"Price Approval":
                begin
                    if PriceApproval.Get(ApprovalEntry."Document No.") then begin
                        PriceApproval.Validate(Status, PriceApproval.Status::Rejected);
                        PriceApproval.Modify(true);
                    end;
                end;
        end;
        case ApprovalEntry."Table ID" of
            DataBase::"Purchase Request Info":
                begin
                    if PurchaseRequestInfo.Get(ApprovalEntry."Document No.") then begin
                        PurchaseRequestInfo.Validate(Status, PurchaseRequestInfo.Status::Rejected);
                        PurchaseRequestInfo.Modify(true);
                    end;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnReleaseDocument', '', false, false)]
    local procedure OnReleaseDocument(RecRef: RecordRef; var Handled: Boolean)
    var
        PriceApproval: Record "Price Approval";
        PurchaseRequestInfo: Record "Purchase Request Info";
    begin
        case RecRef.Number of
            DataBase::"Price Approval":
                begin
                    RecRef.SetTable(PriceApproval);
                    PriceApproval.Validate(Status, PriceApproval.Status::Approved);
                    PriceApproval.Modify(true);
                    Handled := true;
                end;
        end;
        case RecRef.Number of
            DataBase::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequestInfo);
                    PurchaseRequestInfo.Validate(Status, PurchaseRequestInfo.Status::Approved);
                    PurchaseRequestInfo.Modify(true);
                    Handled := true;
                end;
        end;
    end;

    procedure GetStatusStyleText(RecStatus: Enum "Custom Approval Enum") StatusStyleText: Text
    var
        ApprovalStatus: enum "Custom Approval Enum";
    begin
        Case RecStatus Of
            ApprovalStatus::Approved:
                StatusStyleText := 'Favorable';
            ApprovalStatus::Rejected:
                StatusStyleText := 'UnFavorable';
            ApprovalStatus::Pending:
                StatusStyleText := 'Ambiguous';
            ApprovalStatus::OnHold:
                StatusStyleText := 'Attention';
        end;
    end;

    var
        WorkflowMgt: Codeunit "Workflow Management";
        RUNWORKFLOWONSENDFORAPPROVALCODE: Label 'RUNWORKFLOWONSEND%1FORAPPROVAL';
        RUNWORKFLOWONCANCELFORAPPROVALCODE: Label 'RUNWORKFLOWONCANCEL%1FORAPPROVAL';
        NoWorkflowEnabledErr: Label 'No approval workflow for this record type is enabled.';
        WorkflowSendForApprovalEventDescTxt: Label 'Approval of %1 is requested.';
        WorkflowCancelForApprovalEventDescTxt: Label 'Approval of %1 is canceled.';

}