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
                SentAText(user, RecRef.RecordId);
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
                SentAText(user, ApprovalEntry2."Record ID to Approve");
            until ApprovalEntry2.Next() = 0;
    end;

    procedure SentAText(user: Record User; RecId: RecordId)
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
        Message(content);
        EmailTemplate.SetRange("No.", 'PAT01');
        EmailTemplate.FindFirst();
        Body := EmailTemplate.GetContent();
        Body := Body.Replace('[approver-email]', User."Full Name");
        Body := Body.Replace('[content]', content);
        EmailMessage.Create(User."Contact Email", 'Hi', Body, true);
        Mail.Send(EmailMessage, "Email Scenario"::Default);
    end;

    procedure CreateTable(VAR MTRec: Record "Material Tree"): Text
    var
        out: Text;
        stt: Integer;
    begin
        MTRec.FindFirst();
        if MTRec.Count() > 0 then begin
            stt := 1;
            out := '<table class="table table-sm table-bordered fs-6">';
            repeat
                if (MTRec.Indentation = 1) then begin
                    #region TbItem
                    out += '<tr><td>' + MTRec.ItemNo + '</td><td colspan="4">' + MTRec.Description + '</td><td colspan="2">' + MTRec.Quantity + '</td> <td>' + Format(MTRec.Unit) + '</td></tr>';
                    #endregion TbItem
                end;
                if MTRec.Indentation = 0 then begin
                    #region TBinfo
                    if stt > 1 then out += '</tbody>';
                    out += '<tr><td colspan="8"></td><tr>';//! spacing bettwen 2 suplier 
                    out += '<tr class="table-primary text text-center table-borderless" >';//! Header row
                    out += '<td colspan="7">Material ' + Format(stt) + '</td>';
                    out += '<td><div id="btn-placerholder-' + Format(MTRec."Line No.") + '" class ="btn-group"></div></td>'; //! Button group placeHolder
                    out += '</tr>';
                    out += '<tr>';
                    out += '<td class="table-secondary"><label class="control-label">Product code of Manufacturer:</label></td>';
                    out += '<td class="special">' + MTRec."Manufacturer's code:" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Price:</label></td>';
                    out += '<td class="special" ">' + MTRec.Price + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Delivery:</label></td>';
                    out += '<td >' + MTRec.Delivery + '</td>';
                    out += '<td class="table-secondary" ><label class="control-label">Roll length:</label></td>';
                    out += '<td >' + MTRec."Roll length" + '</td>';
                    out += '</tr>';
                    out += '<tr>';
                    out += '<td class="table-secondary"><label class="control-label">Supplier:</label></td>';
                    out += '<td>' + MTRec.Supplier + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Price term:</label></td>';
                    out += '<td>' + MTRec."Price Term" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Pallet/No pallet:</label></td>';
                    out += '<td>' + MTRec."Pallet/No pallet" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Payment term:</label></td>';
                    out += '<td>' + MTRec."Payment term" + '</td>';
                    out += '</tr>';
                    out += '<tr> <td class="table-secondary">Price note</td> <td colspan="7">' + MTRec.GetContent() + '</td></tr>';
                    out += '<tbody class="table-group-divider">';
                    out += '<tr class="table-info"><td>Mtl code</td><td colspan="4">Material name</td><td colspan="2">Quantity</td> <td>Unit</td> </tr>';
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