// codeunit 50105 "Purchase Request Attachment"
// {
//     [EventSubscriber(ObjectType::Page, Page::"Document Attachment Factbox", 'OnBeforeDrillDown', '', false, false)]
//     local procedure OnBeforeDrillDown(DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
//     var
//         PurchaseRequest: Record "Purchase Request Info";
//     begin
//         case DocumentAttachment."Table ID" of
//             DATABASE::"Purchase Request Info":
//                 begin
//                     RecRef.Open(DATABASE::"Purchase Request Info");
//                     if PurchaseRequest.Get(DocumentAttachment."No.") then
//                         RecRef.GetTable(PurchaseRequest);
//                 end;
//         end;
//     end;

//     [EventSubscriber(ObjectType::Page, Page::"Document Attachment Details", 'OnAfterOpenForRecRef', '', false, false)]
//     local procedure OnAfterOpenForRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef);
//     var
//         FieldRef: FieldRef;
//         RecNo: Code[20];
//     begin
//         case RecRef.Number of
//             DATABASE::"Purchase Request Info":
//                 begin
//                     FieldRef := RecRef.Field(1);
//                     RecNo := FieldRef.Value;
//                     DocumentAttachment.SetRange("No.", RecNo);
//                 end;
//         end;
//     end;

//     [EventSubscriber(ObjectType::Table, Database::"Document Attachment", 'OnAfterInitFieldsFromRecRef', '', false, false)]
//     local procedure OnAfterInitFieldsFromRecRef(var DocumentAttachment: Record "Document Attachment"; var RecRef: RecordRef)
//     var
//         FieldRef: FieldRef;
//         RecNo: Code[20];
//     begin
//         case RecRef.Number of
//             DATABASE::"Purchase Request Info":
//                 begin
//                     FieldRef := RecRef.Field(1);
//                     RecNo := FieldRef.Value;
//                     DocumentAttachment.Validate("No.", RecNo);
//                 end;
//         end;
//     end;
// }
