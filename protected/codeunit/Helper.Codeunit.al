codeunit 50104 Helper
{
    procedure CloseConfirmDialog(Question: Text): Boolean
    var
        Selected: Boolean;
    begin
        Selected := Dialog.Confirm(Question, false);
        Exit(Selected)
    end;

    procedure AttachFile(RecRef: RecordRef)
    var
        DocumentAttachmentDetails: Page "Document Attachment Details";
    begin
        DocumentAttachmentDetails.OpenForRecRef(RecRef);
        DocumentAttachmentDetails.RunModal();
    end;

    procedure ItemTenantMediaToBase64(GUID: Guid): Text
    var
        ImgBase64: Text;
        ItemTenantMedia: Record "Tenant Media";
        InStr: InStream;
        Base64Convert: Codeunit "Base64 Convert";
    begin
        ItemTenantMedia.Get(GUID);
        ItemTenantMedia.CalcFields(Content);
        ItemTenantMedia.Content.CreateInStream(InStr, TextEncoding::UTF8);
        ImgBase64 := Base64Convert.ToBase64(InStr, false);
        exit(ImgBase64);
    end;
}
