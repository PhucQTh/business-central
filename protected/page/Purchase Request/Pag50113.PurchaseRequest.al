page 50113 "Purchase Request"
{
    ApplicationArea = All;
    Caption = 'Purchase Request';
    PageType = List;
    SourceTable = "Purchase Request Info";
    UsageCategory = Lists;
    CardPageId = 50114;

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

    actions
    {
        area(Processing)
        {
            action("Reset Filter")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = RemoveFilterLines;

                trigger OnAction()
                begin
                    Rec.SetFilter(Rec.No_, '');
                    Rec.SetFilter(Rec.pr_notes, '');
                    Rec.SetFilter(Rec."Request By", '');
                    Rec.SetFilter(Rec."Status", '');
                    CurrPage.Update();
                end;
            }
            action("My Requests")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CustomerSalutation;

                trigger OnAction()
                begin
                    Rec.SetFilter(Rec."Request By", UserId);
                    CurrPage.Update();
                end;
            }

            action("Waiting")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = CapacityLedger;

                trigger OnAction()
                begin
                    Rec.SetFilter(Rec."Status", Format(Status::Pending));
                    CurrPage.Update();
                end;
            }
            action("Request To Approve")
            {
                ApplicationArea = All;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Image = NewToDo;

                trigger OnAction()
                begin
                    Rec.SetFilter(Rec."Request By", '<>%1', UserId);
                    CurrPage.Update();
                end;
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
            IdFilterString := COPYSTR(IdFilterString, 1, STRLEN(IdFilterString) - 1)
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
