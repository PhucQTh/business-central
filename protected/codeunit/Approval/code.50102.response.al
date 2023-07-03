codeunit 50103 MyWorkflowResponses
{
    procedure SentEmailToApproverCode(): code[128];
    begin
        exit(UpperCase('SentEmailToApprover'));
    end;

    procedure SentEmailNotificationToSenderCode(): code[128]
    begin
        exit(UpperCase('SentEmailNotificationToSender'));
    end;

    procedure SentEmailWhenRejectedCode(): code[128]
    begin
        exit(UpperCase('SentEmailWhenRejected'));
    end;

    procedure SentEmailWhenApprovedCompleteCode(): code[128]
    begin
        exit(UpperCase('SentEmailWhenApprovedComplete'));
    end;


    procedure SentEmailNotificationToSender(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    begin

    end;

    procedure SentEmailWhenSubmitRequest(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecRef: RecordRef;
        ApprovalStatus: Enum "Approval Status";
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                SendApprovalEmailFromApprovalEntry(Variant, WorkflowStepInstance, ApprovalStatus::Open);
            else
                SendApprovalEmailFromApprovalRecord(RecRef, WorkflowStepInstance, ApprovalStatus::Open);
        end;
    end;


    //* Sent Email When Rejected
    procedure SentEmailWhenRejected(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecRef: RecordRef;
        ApprovalStatus: Enum "Approval Status";
    begin
        RecRef.GetTable(Variant);
        case
            RecRef.Number of
            DATABASE::"Approval Entry":
                SendApprovalEmailFromApprovalEntry(Variant, WorkflowStepInstance, ApprovalStatus::Rejected);
            else
                SendApprovalEmailFromApprovalRecord(RecRef, WorkflowStepInstance, ApprovalStatus::Rejected);
        end;
    end;
    //* Sent Email When Approved Complete
    procedure SentEmailWhenApprovedComplete(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecRef: RecordRef;
        ApprovalStatus: Enum "Approval Status";
    begin
        RecRef.GetTable(Variant);
        case
            RecRef.Number of
            DATABASE::"Approval Entry":
                SendApprovalEmailFromApprovalEntry(Variant, WorkflowStepInstance, ApprovalStatus::Approved);
            else
                SendApprovalEmailFromApprovalRecord(RecRef, WorkflowStepInstance, ApprovalStatus::Approved);
        end;
    end;

    procedure SendApprovalEmailFromApprovalRecord(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance"; ApprovalStatus: Enum "Approval Status")
    var
        ApprovalEntry: Record "Approval Entry";
        user: Record User;
    begin
        ApprovalEntry.SetCurrentKey("Table ID", "Record ID to Approve", Status, "Workflow Step Instance ID", "Sequence No.");
        ApprovalEntry.SetRange("Table ID", RecRef.Number);
        ApprovalEntry.SetRange("Record ID to Approve", RecRef.RecordId);
        ApprovalEntry.SetRange(Status, ApprovalStatus);
        ApprovalEntry.SetRange("Workflow Step Instance ID", WorkflowStepInstance.ID);
        if ApprovalEntry.FindFirst() then
            repeat
                user.SetRange("User Name", ApprovalEntry."Approver ID");
                user.FindLast();
                IF ApprovalStatus = ApprovalStatus::Open THEN
                    SentSubmitedEmail(user, RecRef.RecordId, ApprovalEntry."Sender ID");
                IF ApprovalStatus = ApprovalStatus::Rejected THEN
                    SentRejectedEmail(user, RecRef.RecordId, ApprovalEntry."Sender ID");
            until ApprovalEntry.Next() = 0;

        IF ApprovalStatus = ApprovalStatus::Approved THEN begin
            user.SetRange("User Name", ApprovalEntry."Approver ID");
            user.FindLast();
            SentCompletedApprovedEmail(user, RecRef.RecordId, ApprovalEntry."Sender ID");
        end;

    end;

    procedure SendApprovalEmailFromApprovalEntry(ApprovalEntry: Record "Approval Entry"; WorkflowStepInstance: Record "Workflow Step Instance"; ApprovalStatus: Enum "Approval Status")
    var
        ApprovalEntry2: Record "Approval Entry";
        user: Record User;
    begin
        ApprovalEntry2.SetCurrentKey("Table ID", "Document Type", "Document No.", "Sequence No.");
        ApprovalEntry2.SetRange("Record ID to Approve", ApprovalEntry."Record ID to Approve");
        ApprovalEntry2.SetRange(Status, ApprovalStatus);
        if ApprovalEntry2.FindSet() then
            repeat
                user.SetRange("User Name", ApprovalEntry2."Approver ID");
                user.FindLast();
                IF ApprovalStatus = ApprovalStatus::Open THEN
                    SentSubmitedEmail(user, ApprovalEntry2."Record ID to Approve", ApprovalEntry."Sender ID");
                IF ApprovalStatus = ApprovalStatus::Rejected THEN
                    SentRejectedEmail(user, ApprovalEntry2."Record ID to Approve", ApprovalEntry."Sender ID");

            until ApprovalEntry2.Next() = 0;
        IF ApprovalStatus = ApprovalStatus::Approved THEN begin
            user.SetRange("User Name", ApprovalEntry."Approver ID");
            user.FindLast();
            SentCompletedApprovedEmail(user, ApprovalEntry2."Record ID to Approve", ApprovalEntry."Sender ID");
        end;
    end;

    procedure SentSubmitedEmail(user: Record User; RecId: RecordId; SenderId: Code[50])
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        PriceApproval: Record "Price Approval";
        PurchaseRequest: Record "Purchase Request Info";
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    RecRef.SetTable(PriceApproval);
                    URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50101&filter=%27Price%20Approval%27.No_%20IS%20%27#[CODE]%27';
                    URL := URL.Replace('#[CODE]', PriceApproval.No_);
                    EmailTemplate.SetRange("Key", 'SUBMIT_PRICE'); //! Find Email Template
                    EmailTemplate.FindFirst();
                    /* ------------------------------- Get subject ------------------------------ */
                    Subject := EmailTemplate.Subject;
                    Subject := Subject.Replace('#[CODE]', PriceApproval.No_);
                    /* ------------------------------------ i ----------------------------------- */
                    ReqUser.SetRange("User Name", SenderId); //! Find Requested User
                    ReqUser.FindFirst();
                    /* -------------------------------- Get body -------------------------------- */
                    Body := EmailTemplate.GetContent();
                    Body := Body.Replace('[FULL_NAME]', User."Full Name");
                    Body := Body.Replace('[CODE]', PriceApproval.No_);
                    Body := Body.Replace('[REQUESTEDBY]', ReqUser."Full Name");
                    Body := Body.Replace('[RFA_TITLE]', PriceApproval.Title);
                    Body := Body.Replace('[REQUESTED_DATE]', Format(PriceApproval.RequestDate));
                    Body := Body.Replace('[LINK]', URL);
                    CCRecipients := GetCC(PriceApproval.No_);
                    ToRecipients.Add(User."Authentication Email"); //! Add user approver email to to recipients
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
        end;
        case RecRef.Number of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequest);
                    URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
                    URL := URL.Replace('#[CODE]', PurchaseRequest.No_);
                    EmailTemplate.SetRange("Key", 'SUBMIT_PURCHASE');
                    EmailTemplate.FindFirst();
                    /* ------------------------------- Get subject ------------------------------ */
                    Subject := EmailTemplate.Subject;
                    Subject := Subject.Replace('#[CODE]', PurchaseRequest.No_);
                    /* ---------------------------- Find User Request --------------------------- */
                    ReqUser.SetRange("User Name", SenderId);
                    ReqUser.FindFirst();
                    /* -------------------------------- Get body -------------------------------- */
                    Body := EmailTemplate.GetContent();
                    Body := Body.Replace('[CODE]', PurchaseRequest.No_);
                    Body := Body.Replace('[PURPOSE]', PurchaseRequest.pr_notes);
                    Body := Body.Replace('[PS_NO]', PurchaseRequest.ps_no);
                    Body := Body.Replace('[REQUESTEDBY]', ReqUser."Full Name");
                    Body := Body.Replace('[LINK]', URL);
                    if Format(PurchaseRequest.RequestDate) <> '' then
                        Body := Body.Replace('[REQUESTED_DATE]', Format(PurchaseRequest.RequestDate))
                    else
                        Body := Body.Replace('[REQUESTED_DATE]', Format(Today));
                    CCRecipients := GetCC(PurchaseRequest.No_);
                    ToRecipients.Add(User."Authentication Email");
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
        end;
    end;

    procedure SentRejectedEmail(user: Record User; RecId: RecordId; SenderId: Code[50])
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        PriceApproval: Record "Price Approval";
        PurchaseRequest: Record "Purchase Request Info";
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequest);
                    URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
                    URL := URL.Replace('#[CODE]', PurchaseRequest.No_);
                    EmailTemplate.SetRange("Key", 'REJECTED_PURCHASE');
                    EmailTemplate.FindFirst();
                    /* ---------------------------- Get user request ---------------------------- */
                    ReqUser.SetRange("User Name", SenderId);
                    ReqUser.FindFirst();
                    /* ------------------------------- Get subject ------------------------------ */
                    Subject := EmailTemplate.Subject;
                    Subject := Subject.Replace('#[CODE]', PurchaseRequest.No_);
                    /* -------------------------------- Get body -------------------------------- */
                    Body := EmailTemplate.GetContent();
                    Body := Body.Replace('[CODE]', PurchaseRequest.No_);
                    Body := Body.Replace('[PURPOSE]', PurchaseRequest.pr_notes);
                    Body := Body.Replace('[PS_NO]', PurchaseRequest.ps_no);
                    Body := Body.Replace('[REJECT_USER]', ReqUser."Full Name");
                    Body := Body.Replace('[REQUESTEDBY]', user."Full Name");
                    Body := Body.Replace('[LINK]', URL);
                    Body := Body.Replace('[REQUESTED_DATE]', Format(PurchaseRequest.RequestDate));
                    CCRecipients := GetCC(PurchaseRequest.No_);
                    ToRecipients.Add(ReqUser."Authentication Email"); //! In this case - Recipient is requested user
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
        end;
    end;

    procedure SentCompletedApprovedEmail(user: Record User; RecId: RecordId; SenderId: Code[50])
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        PurchaseRequest: Record "Purchase Request Info";
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequest);
                    URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
                    URL := URL.Replace('#[CODE]', PurchaseRequest.No_);
                    ReqUser.SetRange("User Name", SenderId);
                    ReqUser.FindFirst();
                    /* --------------------------- Get email template --------------------------- */
                    EmailTemplate.SetRange("Key", 'APPROVED_COMPLETED_PURCHASE');
                    EmailTemplate.FindFirst();
                    /* ------------------------------- Get subject ------------------------------ */
                    Subject := EmailTemplate.Subject;
                    Subject := Subject.Replace('#[CODE]', PurchaseRequest.No_);
                    /* -------------------------------- Get body -------------------------------- */
                    Body := EmailTemplate.GetContent();
                    Body := Body.Replace('[CODE]', PurchaseRequest.No_);
                    Body := Body.Replace('[PURPOSE]', PurchaseRequest.pr_notes);
                    Body := Body.Replace('[PS_NO]', PurchaseRequest.ps_no);
                    Body := Body.Replace('[REJECT_USER]', ReqUser."Full Name");
                    Body := Body.Replace('[REQUESTEDBY]', user."Full Name");
                    Body := Body.Replace('[LINK]', URL);
                    Body := Body.Replace('[REQUESTED_DATE]', Format(PurchaseRequest.RequestDate));
                    CCRecipients := GetCC(PurchaseRequest.No_);
                    ToRecipients := GetConfirmReceivers(PurchaseRequest.No_); //! In this case - Recipient is received user
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
        end;
    end;

    procedure SentOnHoldEmail(OnHoldedUser: Text; RecId: RecordId)
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        PurchaseRequest: Record "Purchase Request Info";
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
    begin
        RecRef.Get(RecId);
        RecRef.SetTable(PurchaseRequest);
        URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
        URL := URL.Replace('#[CODE]', PurchaseRequest.No_);
        EmailTemplate.SetRange("Key", 'ONHOLD_PURCHASE');
        EmailTemplate.FindFirst();
        /* ---------------------------- Get user request ---------------------------- */
        ReqUser.SetRange("User Name", PurchaseRequest."Request By");
        ReqUser.FindFirst();
        /* ------------------------------- Get subject ------------------------------ */
        Subject := EmailTemplate.Subject;
        Subject := Subject.Replace('#[CODE]', PurchaseRequest.No_);
        /* -------------------------------- Get body -------------------------------- */
        Body := EmailTemplate.GetContent();
        Body := Body.Replace('[CODE]', PurchaseRequest.No_);
        Body := Body.Replace('[PURPOSE]', PurchaseRequest.pr_notes);
        Body := Body.Replace('[PS_NO]', PurchaseRequest.ps_no);
        Body := Body.Replace('[ONHOLD_USER]', OnHoldedUser);
        Body := Body.Replace('[REQUESTEDBY]', PurchaseRequest."Request By");
        Body := Body.Replace('[LINK]', URL);
        Body := Body.Replace('[REQUESTED_DATE]', Format(PurchaseRequest.RequestDate));
        CCRecipients := GetCC(PurchaseRequest.No_);
        ToRecipients.Add(ReqUser."Authentication Email"); //! In this case - Recipient is requested user
        EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
        Mail.Send(EmailMessage, "Email Scenario"::Default);
    end;

    procedure SentConfirmedEmail(ConfirmedUser: Text; RecId: RecordId)
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        PurchaseRequest: Record "Purchase Request Info";
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
    begin
        RecRef.Get(RecId);
        RecRef.SetTable(PurchaseRequest);
        URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
        URL := URL.Replace('#[CODE]', PurchaseRequest.No_);
        EmailTemplate.SetRange("Key", 'CONFIRM_PURCHASE');
        EmailTemplate.FindFirst();
        /* ---------------------------- Get user request ---------------------------- */
        ReqUser.SetRange("User Name", PurchaseRequest."Request By");
        ReqUser.FindFirst();
        /* ------------------------------- Get subject ------------------------------ */
        Subject := EmailTemplate.Subject;
        Subject := Subject.Replace('#[CODE]', PurchaseRequest.No_);
        /* -------------------------------- Get body -------------------------------- */
        Body := EmailTemplate.GetContent();
        Body := Body.Replace('[CODE]', PurchaseRequest.No_);
        Body := Body.Replace('[PURPOSE]', PurchaseRequest.pr_notes);
        Body := Body.Replace('[PS_NO]', PurchaseRequest.ps_no);
        Body := Body.Replace('[ONHOLD_USER]', ConfirmedUser);
        Body := Body.Replace('[REQUESTEDBY]', PurchaseRequest."Request By");
        Body := Body.Replace('[LINK]', URL);
        Body := Body.Replace('[REQUESTED_DATE]', Format(PurchaseRequest.RequestDate));
        CCRecipients := GetCC(PurchaseRequest.No_);
        ToRecipients.Add(ReqUser."Authentication Email"); //! In this case - Recipient is requested user
        EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
        Mail.Send(EmailMessage, "Email Scenario"::Default);
    end;


    procedure GetCC(var RequestId: code[10]): List of [Text] //! Get CC recipients from Collaborators
    var
        ListCC: List of [Text];
        Collaborators: Record "Email CC";
    begin
        Collaborators.SetRange(ApprovalID, RequestId);
        if Collaborators.FindFirst() then
            repeat
                ListCC.Add(Collaborators."Email");
            until Collaborators.Next() = 0;
        exit(ListCC);
    end;

    procedure GetConfirmReceivers(var RequestId: code[10]): List of [Text]
    var
        Receivers: List of [Text];
        ReceiverRecord: Record "Purchase Request Confirm";
        UserRef: Record "User";
    begin
        ReceiverRecord.SetRange(RequestCode, RequestId);
        if ReceiverRecord.FindFirst() then
            repeat
                UserRef.SetRange("User Name", ReceiverRecord."Confirm by");
                UserRef.FindFirst();
                Receivers.Add(UserRef."Authentication Email");
            until ReceiverRecord.Next() = 0;
        exit(Receivers);
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure AddMyWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SentEmailToApproverCode, 0, 'Sent Email To Approver', 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SentEmailNotificationToSenderCode, 0, 'Sent Notification Email To Sender', 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SentEmailWhenRejectedCode, 0, 'Sent Rejected Email', 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SentEmailWhenApprovedCompleteCode, 0, 'Sent Approve Complete Email', 'GROUP 0');

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
                        SentEmailWhenSubmitRequest(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := TRUE;
                    end;

            END;
        case WorkflowResponse."Function Name" of
            SentEmailNotificationToSenderCode:
                begin
                    SentEmailNotificationToSender(Variant, ResponseWorkflowStepInstance);
                    ResponseExecuted := TRUE;
                end;
        END;
        case WorkflowResponse."Function Name" of
            SentEmailWhenRejectedCode:
                begin
                    SentEmailWhenRejected(Variant, ResponseWorkflowStepInstance);
                    ResponseExecuted := TRUE;
                end;
        END;
        case WorkflowResponse."Function Name" of
            SentEmailWhenApprovedCompleteCode:
                begin
                    SentEmailWhenApprovedComplete(Variant, ResponseWorkflowStepInstance);
                    ResponseExecuted := TRUE;
                end;
        END;
    end;


    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";

}