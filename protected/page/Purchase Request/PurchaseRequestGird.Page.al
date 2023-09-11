page 50136 "Purchase Request Gird"
{
    Caption = 'Purchase Request Gird';
    PageType = ListPart;
    SourceTable = "Purchase Request Info";
    Editable = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No_; Rec.No_)
                {
                    Caption = 'No.';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the id field.';
                    trigger OnDrillDown()
                    var
                        Selection: Integer;
                        PurchPage: Page "Purchase Request Card";
                    begin
                        PurchPage.SetRecord(Rec);
                        PurchPage.Run();
                    end;
                }
                field(Status; Rec.Status)
                {
                    StyleExpr = StatusStyleTxt;
                    Caption = 'Status';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the id field.';
                }

                field(pr_notes; Rec.pr_notes)
                {
                    Caption = 'Purpose';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the pr_notes field.';
                }
                field(TenBoPhan; Rec.TenBoPhan)
                {
                    Caption = 'Department';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the TenBoPhan field.';
                }

                field("Request By"; Rec."Request By")
                {
                    Caption = 'Request By';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the NguoiYeuCau field.';
                }
            }
        }

    }
    trigger OnAfterGetRecord()
    var
        CustomWflMgmt: Codeunit "Approval Wfl Mgt";
    begin
        StatusStyleTxt := CustomWflMgmt.GetStatusStyleText(Rec.Status);
    end;

    procedure GetFilterString()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovalMgmt: Codeunit "Approval Wfl Mgt";
        Collaborators: Record "Email CC";
        isCollaborator: Boolean;
        ConfirmReceiver: Record "Purchase Request Confirm";
        isConfirmReceiver: Boolean;
    begin
        Rec.FindFirst();
        repeat
            isCollaborator := false;
            Collaborators.SetRange("ApprovalId", Rec.NO_);
            Collaborators.SetRange("UserName", UserId);
            if (Collaborators.FindSet()) then isCollaborator := true;
            isConfirmReceiver := false;
            ConfirmReceiver.SetRange("Confirm by", UserId);
            ConfirmReceiver.SetRange(RequestCode, Rec.NO_);
            if (ConfirmReceiver.FindSet()) then isConfirmReceiver := true;
            if (CustomApprovalMgmt.HasApprovalEntriesForCurrentUser(Rec.RecordId)) OR (Rec."Request By" = UserId) OR (isCollaborator) OR (isConfirmReceiver) then //AND (Rec.Status <> ApprovalStatus::Open)
                IdFilterString := IdFilterString + Rec.No_ + '|'
        until Rec.Next() = 0;
        if IdFilterString.LastIndexOf('|') > 0 then
            IdFilterString := COPYSTR(IdFilterString, 1, STRLEN(IdFilterString) - 1);
        if IdFilterString.StartsWith('|') then IdFilterString := IdFilterString.Remove(1, 1);
    end;

    trigger OnOpenPage()
    var
        filteredRec: Record "Purchase Request Info" temporary;
    begin
        If Rec.Count < 1 then exit;
        GetFilterString();
        if (IdFilterString <> '')
      then begin
            Rec.FilterGroup := 100;
            Rec.SetFilter(Rec.No_, IdFilterString);
            Rec.FilterGroup := 0;
        end
        else begin
            Rec.FilterGroup := 100;
            Rec.SetFilter(Rec."Request By", UserId);
            Rec.FilterGroup := 0;
        end;
    end;



    var
        StatusStyleTxt: Text;
        IdFilterString: Text;
        status: enum "Custom Approval Enum";

}
