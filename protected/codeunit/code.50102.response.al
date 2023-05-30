codeunit 50103 MyWorkflowResponses
{
    procedure SentEmailToApproverCode(): code[128];
    begin
        exit(UpperCase('SentEmailToApprover'));
    end;

    procedure InitialSentEmailToApprovalCode(): code[128];
    begin
        exit(UpperCase('InitialSentEmailToApproval'));
    end;

    procedure SentEmailToApprover(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                // begin
                SendApprovalEmailFromApprovalEntry(Variant, WorkflowStepInstance);
            // end;
            else
                SendApprovalEmailFromApprovalRecord(RecRef, WorkflowStepInstance);
        end;
    end;

    procedure SendApprovalEmailFromApprovalRecord(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalEntry: Record "Approval Entry";
        user: Record User;
    begin
        ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", Status, "Workflow Step Instance ID", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", RecRef.Number);
        ApprovalEntry.SetRange("Record ID to Approve", RecRef.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalEntry.Status::Open);
        ApprovalEntry.SetRange("Workflow Step Instance ID", WorkflowStepInstance.ID);
        if ApprovalEntry.FindFirst() then
            repeat
                user.SetRange("User Name", ApprovalEntry."Approver ID");
                user.FindFirst();
                SentAText(user);
            until ApprovalEntry.Next() = 0;
    end;

    procedure SendApprovalEmailFromApprovalEntry(ApprovalEntry: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        ApprovalEntry2: Record "Approval Entry";
        ApprovalStatus: Enum "Approval Status";
        user: Record User;
    begin
        ApprovalEntry2.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalEntry2.SetRange(Status, ApprovalStatus::Open);
        if ApprovalEntry2.FindSet() then
            repeat
                user.SetRange("User Name", ApprovalEntry2."Approver ID");
                user.FindFirst();
                SentAText(user);
            until ApprovalEntry2.Next() = 0;
    end;

    procedure SentAText(user: Record User)
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        EmailTemplate: Record "Email Template";
    begin
        EmailTemplate.SetRange("No.", 'PAT01');
        EmailTemplate.FindFirst();
        Body := EmailTemplate.GetContent();
        Body := Body.Replace('[approver-email]', User."Full Name");
        EmailMessage.Create(User."Contact Email", 'Hi', Body, true);
        Mail.Send(EmailMessage, "Email Scenario"::Default);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure AddMyWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SentEmailToApproverCode, 0, 'Sent Email To Approver', 'GROUP 0');
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnExecuteWorkflowResponse', '', true, true)]
    procedure ExecuteMyWorkflowResponses(ResponseWorkflowStepInstance: Record "Workflow Step Instance"; var ResponseExecuted: Boolean; var Variant: Variant; xVariant: Variant)
    var
        WorkflowResponse: record "Workflow Response";
    begin
        if WorkflowResponse.GET(ResponseWorkflowStepInstance."Function Name") then
            case WorkflowResponse."Function Name" of
                SentEmailToApproverCode:
                    begin
                        SentEmailToApprover(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := TRUE;
                    end;

            END;
    end;

    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";

}