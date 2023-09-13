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

    procedure SetApprovedStatusCode(): code[128]
    begin
        exit(UpperCase('SetApprovedStatus'));
    end;

    procedure GetApproversListCode(): code[128]
    begin
        exit(UpperCase('GetApproversList'));
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
                    SentSubmitedEmail(user, RecRef.RecordId);
                IF ApprovalStatus = ApprovalStatus::Rejected THEN
                    SentRejectedEmail(user, RecRef.RecordId);
            until ApprovalEntry.Next() = 0;

        IF ApprovalStatus = ApprovalStatus::Approved THEN begin
            user.SetRange("User Name", ApprovalEntry."Approver ID");
            user.FindLast();
            SentCompletedApprovedEmail(user, RecRef.RecordId);
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
                    SentSubmitedEmail(user, ApprovalEntry2."Record ID to Approve");
                IF ApprovalStatus = ApprovalStatus::Rejected THEN
                    SentRejectedEmail(user, ApprovalEntry2."Record ID to Approve");
            until ApprovalEntry2.Next() = 0;
        IF ApprovalStatus = ApprovalStatus::Approved THEN begin
            user.SetRange("User Name", ApprovalEntry."Approver ID");
            user.FindLast();
            SentCompletedApprovedEmail(user, ApprovalEntry2."Record ID to Approve");
        end;
    end;

    procedure SentSubmitedEmail(user: Record User; RecId: RecordId)
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        EmailTemplate: Record "Email Template";
        Body: Text;
        Subject: Text;
        RecRef: RecordRef;
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
        //*  Table define  */
        PriceApproval: Record "Price Approval";
        PurchaseRequest: Record "Purchase Request Info";
        CylinderRequest: Record "Cylinder Info";
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
                    ReqUser.SetRange("User Name", PriceApproval."Request By"); //! Find Requested User
                    ReqUser.FindFirst();
                    /* -------------------------------- Get body -------------------------------- */
                    Body := EmailTemplate.GetContent();
                    Body := Body.Replace('[FULL_NAME]', User."Full Name");
                    Body := Body.Replace('[CODE]', PriceApproval.No_);
                    Body := Body.Replace('[REQUESTEDBY]', ReqUser."Full Name");
                    Body := Body.Replace('[RFA_TITLE]', PriceApproval.Title);
                    Body := Body.Replace('[REQUESTED_DATE]', Format(PriceApproval.RequestDate));
                    Body := Body.Replace('[LINK]', URL);
                    CCRecipients := GetCollaborators(PriceApproval.No_);
                    ToRecipients.Add(User."Authentication Email"); //! Add user approver email to to recipients
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
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
                    ReqUser.SetRange("User Name", PurchaseRequest."Request By");
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
                    CCRecipients := GetCollaborators(PurchaseRequest.No_);
                    ToRecipients.Add(User."Authentication Email");
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
            Database::"cylinder info":
                begin
                    // TODO : Remember me!
                    RecRef.SetTable(CylinderRequest);
                    URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
                    URL := URL.Replace('#[CODE]', CylinderRequest.No_);
                    EmailTemplate.SetRange("Key", 'SUBMIT_PURCHASE');
                    EmailTemplate.FindFirst();
                    /* ------------------------------- Get subject ------------------------------ */
                    Subject := EmailTemplate.Subject;
                    Subject := Subject.Replace('#[CODE]', CylinderRequest.No_);
                    /* ---------------------------- Find User Request --------------------------- */
                    // ReqUser.SetRange("User Name", CyinderRequest."Request By");
                    ReqUser.FindFirst();
                    /* -------------------------------- Get body -------------------------------- */
                    Body := EmailTemplate.GetContent();
                    // Body := Body.Replace('[CODE]', CyinderRequest.No_);
                    // Body := Body.Replace('[PURPOSE]', PurchaseRequest.pr_notes);
                    // Body := Body.Replace('[PS_NO]', PurchaseRequest.ps_no);
                    // Body := Body.Replace('[REQUESTEDBY]', ReqUser."Full Name");
                    Body := Body.Replace('[LINK]', URL);
                    // if Format(CyinderRequest.RequestDate) <> '' then
                    //     Body := Body.Replace('[REQUESTED_DATE]', Format(CyinderRequest.RequestDate))
                    // else
                    //     Body := Body.Replace('[REQUESTED_DATE]', Format(Today));
                    CCRecipients := GetCollaborators(CylinderRequest.No_);
                    ToRecipients.Add(User."Authentication Email");
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
        end;
    end;

    procedure SentRejectedEmail(user: Record User; RecId: RecordId)
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
        //* TABLE DEFINE */
        PurchaseRequest: Record "Purchase Request Info";
        PriceRequest: Record "Price Approval";
        CylinderRequest: Record "cylinder info";
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    // TODO : Remember me!
                    RecRef.SetTable(PriceRequest);
                end;
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequest);
                    URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
                    URL := URL.Replace('#[CODE]', PurchaseRequest.No_);
                    EmailTemplate.SetRange("Key", 'REJECTED_PURCHASE');
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
                    Body := Body.Replace('[REJECT_USER]', ReqUser."Full Name");
                    Body := Body.Replace('[REQUESTEDBY]', user."Full Name");
                    Body := Body.Replace('[LINK]', URL);
                    Body := Body.Replace('[REQUESTED_DATE]', Format(PurchaseRequest.RequestDate));
                    CCRecipients := GetCollaborators(PurchaseRequest.No_);
                    ToRecipients.Add(ReqUser."Authentication Email"); //! In this case - Recipient is requested user
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
            Database::"cylinder info":
                begin
                    // TODO : Remember me!
                end;
        end;
    end;

    procedure SentCompletedApprovedEmail(user: Record User; RecId: RecordId)
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
        //* TABLE DEFINE */
        PurchaseRequest: Record "Purchase Request Info";
        PriceRequest: Record "Price Approval";
        CylinderRequest: Record "cylinder info";
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    // TODO : Remember me!
                    // RecRef.SetTable(PriceApproval);
                end;
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequest);
                    URL := 'https://businesscentral.dynamics.com/Sandbox/?company=CRONUS%20USA%2c%20Inc.&page=50113&filter=%27Purchase%20Request%20Info%27.No_%20IS%20%27#[CODE]%27';
                    URL := URL.Replace('#[CODE]', PurchaseRequest.No_);
                    ReqUser.SetRange("User Name", PurchaseRequest."Request By");
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
                    CCRecipients := GetCollaborators(PurchaseRequest.No_);
                    ToRecipients := GetConfirmReceivers(PurchaseRequest.No_); //! In this case - Recipient is received user
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
            Database::"cylinder info":
                begin
                    // TODO : Remember me!
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
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
        //* TABLE DEFINE */
        PurchaseRequest: Record "Purchase Request Info";
        PriceRequest: Record "Price Approval";
        CylinderRequest: Record "cylinder info";
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    // TODO : Remember me!
                    // RecRef.SetTable(PriceApproval);
                end;
            Database::"Purchase Request Info":
                begin
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
                    CCRecipients := GetCollaborators(PurchaseRequest.No_);
                    ToRecipients.Add(ReqUser."Authentication Email"); //! In this case - Recipient is requested user
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
            Database::"cylinder info":
                begin
                    // TODO : Remember me!
                end;
        end;
    end;

    procedure SentConfirmedEmail(ConfirmedUser: Text; RecId: RecordId)
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        Subject: Text;
        EmailTemplate: Record "Email Template";
        RecRef: RecordRef;
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
        URL: Text;
        //* TABLE DEFINE */
        PurchaseRequest: Record "Purchase Request Info";
        PriceRequest: Record "Price Approval";
        CylinderRequest: Record "cylinder info";
    begin

        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    // TODO : Remember me!
                    // RecRef.SetTable(PriceApproval);
                end;
            Database::"Purchase Request Info":
                begin
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
                    CCRecipients := GetCollaborators(PurchaseRequest.No_);
                    ToRecipients.Add(ReqUser."Authentication Email"); //! In this case - Recipient is requested user
                    EmailMessage.Create(ToRecipients, Subject, Body, true, CCRecipients, BCCRecipients);
                    Mail.Send(EmailMessage, "Email Scenario"::Default);
                end;
            Database::"cylinder info":
                begin
                    // TODO : Remember me!
                end;
        end;

    end;

    procedure SentDelegatedEmail(user: Record User; RecId: RecordId)
    var
        RecRef: RecordRef;
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    // TODO : Remember me!
                    // RecRef.SetTable(PriceApproval);
                end;
            Database::"Purchase Request Info":
                begin
                    // TODO : Remember me!
                end;
            Database::"cylinder info":
                begin
                    // TODO : Remember me!
                end;
        end;
    end;

    procedure GetCollaborators(var RequestId: code[10]): List of [Text] //! Get CC recipients from Collaborators
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
        WorkflowResponseHandling.AddResponseToLibrary(SetApprovedStatusCode, 0, 'Set Approved Status', 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(GetApproversListCode(), 0, 'Get Approvers List', 'GROUP 0');
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
                SentEmailNotificationToSenderCode:
                    begin
                        SentEmailNotificationToSender(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := TRUE;
                    end;
                SentEmailWhenRejectedCode:
                    begin
                        SentEmailWhenRejected(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := TRUE;
                    end;
                SentEmailWhenApprovedCompleteCode:
                    begin
                        SentEmailWhenApprovedComplete(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := TRUE;
                    end;
                SetApprovedStatusCode:
                    begin
                        SetRequestStatusToApproved(Variant);
                        ResponseExecuted := TRUE;
                    end;
                GetApproversListCode:
                    begin
                        CreateApprovalRequests(Variant, ResponseWorkflowStepInstance);
                        ResponseExecuted := TRUE;
                    end;
            END;
    end;


    procedure SetRequestStatusToApproved(ApprovalEntry: Record "Approval Entry")
    var
        RecRef: RecordRef;
        Status: Enum "Custom Approval Enum";
        //* Table define 
        PriceApproval: Record "Price Approval";
        PurchaseRequestInfo: Record "Purchase Request Info";
        CylinderRequest: Record "Cylinder Info";
    begin
        case ApprovalEntry."Table ID" of
            DataBase::"Purchase Request Info":
                begin
                    RecRef.Get(ApprovalEntry."Record ID to Approve");
                    RecRef.SetTable(PurchaseRequestInfo);
                    PurchaseRequestInfo.find();
                    PurchaseRequestInfo.Validate(Status, Status::Approved);
                    PurchaseRequestInfo.Modify(true);
                end;
            DataBase::"Price Approval":
                begin
                    RecRef.Get(ApprovalEntry."Record ID to Approve");
                    RecRef.SetTable(PriceApproval);
                    PriceApproval.find();
                    PriceApproval.Validate(Status, Status::Approved);
                    PriceApproval.Modify(true);
                end;
            DataBase::"Cylinder Info":
                begin
                    RecRef.Get(ApprovalEntry."Record ID to Approve");
                    RecRef.SetTable(CylinderRequest);
                    CylinderRequest.find();
                    CylinderRequest.Validate(Status, Status::Approved);
                    CylinderRequest.Modify(true);
                end;
        end;
    end;
    /* -------------- Create Approval Requests folow Approvers List ------------- */
    /* ---------------------------------- BEGIN --------------------------------- */
    /* -------------- This code base on Workflow Response Handling -------------- */
    procedure CreateApprovalRequests(RecRef: RecordRef; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        WorkflowStepArgument: Record "Workflow Step Argument";
        ApprovalEntryArgument: Record "Approval Entry";
        IsHandled: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";

    begin
        ApprovalsMgmt.PopulateApprovalEntryArgument(RecRef, WorkflowStepInstance, ApprovalEntryArgument);
        CreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument, ApprovalEntryArgument);
        OnCreateApprovalRequestsOnAfterCreateRequests(RecRef, WorkflowStepArgument, ApprovalEntryArgument);
        if WorkflowStepArgument."Show Confirmation Message" then
            ApprovalsMgmt.InformUserOnStatusChange(RecRef, WorkflowStepInstance.ID);
    end;
    /* -------------------- This code base on Approvals Mgmt. ------------------- */
    local procedure CreateApprReqForApprTypeWorkflowUserGroup(WorkflowStepArgument: Record "Workflow Step Argument"; ApprovalEntryArgument: Record "Approval Entry")
    var
        UserSetup: Record "User Setup";
        ApproverId: Code[50];
        SequenceNo: Integer;
        IsHandled: Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        ApproversMember: Record "Approval Workflow User Step";
        RecRef: RecordRef;
        RequestId: Code[20];
        //* Table define
        PurchaseRequestInfo: Record "Purchase Request Info";
        PriceApproval: Record "Price Approval";
        CylinderRequest: Record "Cylinder Info";
    begin
        /* ------------------------------------ * ----------------------------------- */
        RecRef.Get(ApprovalEntryArgument."Record ID to Approve");
        case
            ApprovalEntryArgument."Table ID" of
            Database::"Purchase Request Info":
                begin
                    RecRef.SetTable(PurchaseRequestInfo);
                    RequestId := PurchaseRequestInfo.No_;
                end;
            Database::"Price Approval":
                begin
                    RecRef.SetTable(PriceApproval);
                    RequestId := PriceApproval.No_;
                end;
            Database::"Cylinder Info":
                begin
                    RecRef.SetTable(CylinderRequest);
                    RequestId := CylinderRequest.No_;
                end;
        end;
        /* ------------------------------------ * ----------------------------------- */
        IsHandled := false;
        // OnBeforeCreateApprReqForApprTypeWorkflowUserGroup(WorkflowUserGroupMember, WorkflowStepArgument, ApprovalEntryArgument, SequenceNo, IsHandled);
        if not IsHandled then begin
            if not UserSetup.Get(UserId) then
                Error(UserIdNotInSetupErr, UserId);
            SequenceNo := ApprovalsMgmt.GetLastSequenceNo(ApprovalEntryArgument);
            ApproversMember.SetCurrentKey(RequestId, "Sequence No.");
            ApproversMember.SetRange(RequestId, RequestId);
            if not ApproversMember.FindSet() then
                Error(NoWFUserGroupMembersErr) else
                repeat
                    ApproverId := ApproversMember."User name";
                    if not UserSetup.Get(ApproverId) then
                        Error(WFUserGroupNotInSetupErr, ApproverId);
                    IsHandled := false;
                    if not IsHandled then
                        ApprovalsMgmt.MakeApprovalEntry(ApprovalEntryArgument, SequenceNo + ApproversMember."Sequence No.", ApproverId, WorkflowStepArgument);
                until ApproversMember.Next() = 0;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateApprovalRequestsOnAfterCreateRequests(RecRef: RecordRef; WorkflowStepArgument: Record "Workflow Step Argument"; var ApprovalEntryArgument: Record "Approval Entry")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateApprReqForApprTypeWorkflowUserGroupOnBeforeMakeApprovalEntry(var WorkflowUserGroupMember: Record "Workflow User Group Member"; var ApprovalEntryArgument: Record "Approval Entry"; WorkflowStepArgument: Record "Workflow Step Argument"; var ApproverId: Code[50]; var IsHandled: Boolean)
    begin
    end;
    /* ----------------------------------- END ---------------------------------- */
    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";
        WFUserGroupNotInSetupErr: Label 'The workflow user group member with user ID %1 does not exist in the Approval User Setup window.', Comment = 'The workflow user group member with user ID NAVUser does not exist in the Approval User Setup window.';
        NoWFUserGroupMembersErr: Label 'A workflow user group with at least one member must be set up.';
        UserIdNotInSetupErr: Label 'User ID %1 does not exist in the Approval User Setup window.', Comment = 'User ID NAVUser does not exist in the Approval User Setup window.';


}