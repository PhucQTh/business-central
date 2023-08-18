codeunit 50102 ApprovalAttachment
{
    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
    local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        PriceApproval: Record "Price Approval";
        PurchaseRequest: Record "Purchase Request Info";
        CylinderRequest: Record "cylinder info";
    begin
        case DocumentAttachment."Table ID" of
            DATABASE::"Price Approval":
                begin
                    RecRef.Open(DATABASE::"Purchase Request Info");
                    if PriceApproval.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PriceApproval);
                end;
            DATABASE::"Purchase Request Info":
                begin
                    RecRef.Open(DATABASE::"Purchase Request Info");
                    if PurchaseRequest.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(PurchaseRequest);
                end;
            DATABASE::"cylinder info":
                begin
                    RecRef.Open(DATABASE::"cylinder info");
                    if CylinderRequest.Get(DocumentAttachment."No.") then
                        RecRef.GetTable(CylinderRequest);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
    local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
        Selected: Integer;
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request Info":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Price Approval":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
            DATABASE::"Cylinder info":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.SetRange("No.", RecNo);
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
    local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
    var
        FieldRef: FieldRef;
        RecNo: Code[20];
    begin
        case RecRef.Number of
            DATABASE::"Purchase Request Info":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"Price Approval":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
            DATABASE::"cylinder info":
                begin
                    FieldRef := RecRef.Field(1);
                    RecNo := FieldRef.Value;
                    DocumentAttachment.Validate("No.", RecNo);
                end;
        end;
    end;
}
