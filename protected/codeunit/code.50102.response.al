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

    procedure SentEmailNotificationToSender(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    begin

    end;

    procedure SentEmailToApprover(Variant: Variant; WorkflowStepInstance: Record "Workflow Step Instance")
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(Variant);
        case RecRef.Number of
            DATABASE::"Approval Entry":
                SendApprovalEmailFromApprovalEntry(Variant, WorkflowStepInstance);
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
                SentAText(user, RecRef.RecordId, ApprovalEntry."Sender ID");
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
                SentAText(user, ApprovalEntry2."Record ID to Approve", ApprovalEntry2."Sender ID");
            until ApprovalEntry2.Next() = 0;
    end;

    procedure SentAText(user: Record User; RecId: RecordId; SenderId: Code[50])
    var
        Mail: Codeunit "Email";
        EmailMessage: Codeunit "Email Message";
        Body: Text;
        content: text;
        EmailTemplate: Record "Email Template";
        MaterialTreeRec: Record "Material Tree";
        MaterialTreeFunction: Codeunit MaterialTreeFunction;
        RecRef: RecordRef;
        PriceApproval: Record "Price Approval";
        CCRecipients: list of [text];
        ToRecipients: list of [text];
        BCCRecipients: list of [text];
        ReqUser: Record User;
    begin
        RecRef.Get(RecId);
        case RecRef.Number of
            Database::"Price Approval":
                begin
                    RecRef.SetTable(PriceApproval);
                    MaterialTreeFunction.CreateMaterialEntries(MaterialTreeRec, PriceApproval.No_);
                    MaterialTreeRec.FindFirst();
                end;
        end;
        content := CreateTable(MaterialTreeRec);
        EmailTemplate.SetRange("No.", 'PAT01');
        EmailTemplate.FindFirst();
        Body := EmailTemplate.GetContent();
        Body := Body.Replace('[approver-email]', User."Full Name");
        ReqUser.SetRange("User Name", SenderId);
        ReqUser.FindFirst();
        Body := Body.Replace('[req-mail]', ReqUser."Full Name");
        Body := Body.Replace('[content]', content);
        CCRecipients := GetCC(MaterialTreeRec.Code);
        ToRecipients.Add(User."Authentication Email");
        EmailMessage.Create(ToRecipients, 'Hi', Body, true, CCRecipients, BCCRecipients);

        Mail.Send(EmailMessage, "Email Scenario"::Default);
    end;

    procedure GetCC(var RequestId: code[10]): List of [Text]
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

    procedure CreateTable(VAR MTRec: Record "Material Tree"): Text
    var
        out: Text;
        stt: Integer;
    begin
        MTRec.FindFirst();
        if MTRec.Count() > 0 then begin
            stt := 1;
            out := '<table style="border: 1px solid black;">';
            repeat
                if (MTRec.Indentation = 1) then begin
                    #region TbItem
                    out += '<tr style="border: 1px solid black;"><td style="border: 1px solid black;">' + MTRec.ItemNo + '</td><td colspan="4" style="border: 1px solid black;">' + MTRec.Description + '</td><td colspan="2" style="border: 1px solid black;">' + MTRec.Quantity + '</td> <td style="border: 1px solid black;">' + Format(MTRec.Unit) + '</td></tr>';
                    #endregion TbItem
                end;
                if MTRec.Indentation = 0 then begin
                    #region TBinfo
                    if stt > 1 then out += '</tbody>';
                    out += '<tr><td colspan="8"></td><tr>';//! spacing bettwen 2 suplier 
                    out += '<tr>';//! Header row
                    out += ' <td colspan="8" style="border: 1px solid black; background-color: lightblue; text-align: center;"bgcolor="lightblue" align="center">Material ' + Format(stt) + '</td>';
                    out += '</tr>';
                    out += '<tr style="border: 1px solid black;">';
                    out += '<td style="border: 1px solid black;"><label class="control-label">Product code of Manufacturer:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec."Manufacturer's code:" + '</td>';
                    out += '<td style="border: 1px solid black;"><label class="control-label">Price:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec.Price + '</td>';
                    out += '<td style="border: 1px solid black;"><label class="control-label">Delivery:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec.Delivery + '</td>';
                    out += '<td style="border: 1px solid black;"><label class="control-label">Roll length:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec."Roll length" + '</td>';
                    out += '</tr>';
                    out += '<tr style="border: 1px solid black;">';
                    out += '<td style="border: 1px solid black;"><label class="control-label">Supplier:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec.Supplier + '</td>';
                    out += '<td style="border: 1px solid black;"><label class="control-label">Price term:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec."Price Term" + '</td>';
                    out += '<td style="border: 1px solid black;"><label class="control-label">Pallet/No pallet:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec."Pallet/No pallet" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Payment term:</label></td>';
                    out += '<td style="border: 1px solid black;">' + MTRec."Payment term" + '</td>';
                    out += '</tr>';
                    out += '<tr style="border: 1px solid black;"> <td style="border: 1px solid black;">Price note</td> <td colspan="7" style="border: 1px solid black;">' + MTRec.GetContent() + '</td></tr>';
                    out += '<tbody class="table-group-divider">';
                    out += '<tr style="border: 1px solid black;"><td style="border: 1px solid black;">Mtl code</td><td colspan="4" style="border: 1px solid black;">Material name</td><td colspan="2" style="border: 1px solid black;">Quantity</td> <td style="border: 1px solid black;">Unit</td> </tr>';
                    #endregion TBinfo
                    stt += 1;
                end;
            until MTRec.Next() = 0;
        end;
        out += '</table>';
        exit(out);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Workflow Response Handling", 'OnAddWorkflowResponsesToLibrary', '', true, true)]
    local procedure AddMyWorkflowResponsesToLibrary()
    begin
        WorkflowResponseHandling.AddResponseToLibrary(SentEmailToApproverCode, 0, 'Sent Email To Approver', 'GROUP 0');
        WorkflowResponseHandling.AddResponseToLibrary(SentEmailNotificationToSenderCode, 0, 'Sent Notification Email To Sender', 'GROUP 0');
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
        case WorkflowResponse."Function Name" of
            SentEmailNotificationToSenderCode:
                begin
                    SentEmailNotificationToSender(Variant, ResponseWorkflowStepInstance);
                    ResponseExecuted := TRUE;
                end;

        END;
    end;


    var
        WorkflowResponseHandling: Codeunit "Workflow Response Handling";

}