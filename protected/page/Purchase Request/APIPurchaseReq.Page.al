page 50130 APIPurchaseReq
{
    APIGroup = 'apiGroup';
    APIPublisher = 'publisherName';
    APIVersion = 'v2.0';
    Caption = 'apiPurchaseReq';
    DelayedInsert = true;
    EntityName = 'entityName';
    EntitySetName = 'entitySetName';
    PageType = API;
    SourceTable = "Purchase Request Info";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(dienGiaiChung; Rec.DienGiaiChung)
                {
                    Caption = 'DienGiaiChung';
                }
                field(ngayGetPs; Rec.NgayGetPs)
                {
                    Caption = 'NgayGetPs';
                }
                field(ngayPsNhap; Rec.NgayPsNhap)
                {
                    Caption = 'NgayPsNhap';
                }
                field(no; Rec.No_)
                {
                    Caption = 'No.';
                }
                field(prNotes; Rec.pr_notes)
                {
                    Caption = 'pr_notes';
                }
                field(prNumber; Rec.pr_number)
                {
                    Caption = 'pr_number';
                }
                field(prPhone; Rec.pr_phone)
                {
                    Caption = 'pr_phone';
                }
                field(prType; Rec.pr_type)
                {
                    Caption = 'pr_type';
                }
                field(psNo; Rec.ps_no)
                {
                    Caption = 'ps_no';
                }
                field(requestApprovalId; Rec.request_approval_id)
                {
                    Caption = 'request_approval_id';
                }
                field(noSeries; Rec."No. Series")
                {
                    Caption = 'No. Series';
                }
                field("requestBy"; Rec."Request By")
                {
                    Caption = 'No. Series';
                }
            }
        }
    }
    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.pr_notes := 'Xin chao';
    end;
}
