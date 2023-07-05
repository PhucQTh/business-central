page 50101 "Price Approvals"
{
    ApplicationArea = All;
    Caption = 'Price Approvals';
    PageType = List;
    SourceTable = "Price Approval";
    CardPageId = "Price Approval";
    UsageCategory = Lists;
    ShowFilter = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                Editable = false;
                field(No_; Rec.NO_)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                }
                field("Title"; Rec.Title)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Title field.';
                }
                field("Request By"; Rec."Request By")
                {
                    Caption = 'Request by';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Request by field.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Status field.';
                    StyleExpr = StatusStyleTxt;
                }
                field("Due Date"; Rec."Due Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Due Date field.';
                }

                field(SystemCreatedAt; Rec.SystemCreatedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemCreatedAt field.';
                }

                field(SystemModifiedAt; Rec.SystemModifiedAt)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the SystemModifiedAt field.';
                }
            }
        }
    }
    actions
    {
        area(reporting)
        {
            action("Export Report")
            {
                // Promoted = true;
                ApplicationArea = All;
                Caption = 'Export Report';
                trigger OnAction()
                var
                    exportReport: Report "Price Approval Report";
                begin
                    exportReport.Run();
                end;
            }
        }
        area(Navigation)
        {
            action("Request list")
            {
                // Promoted = true;
                ApplicationArea = All;
                Caption = 'Request list';
                trigger OnAction()
                var
                    ReqPage: Page "Price Approval Request";
                begin
                    ReqPage.Run();
                end;
            }

        }
    }
    trigger OnAfterGetRecord()
    var
        Wf: Codeunit "Approval Wfl Mgt";
    begin
        StatusStyleTxt := Wf.GetStatusStyleText(Rec.Status);
    end;



    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        filteredRec: Record "Price Approval" temporary;
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

    trigger OnModifyRecord(): Boolean
    begin
        CurrPage.Update(true);
    end;

    procedure GetFilterString()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovalMgmt: Codeunit "Approval Wfl Mgt";
        Collaborators: Record "Email CC";
        isCollaborator: Boolean;
    begin
        Rec.FindFirst();
        repeat
            isCollaborator := false;
            Collaborators.SetRange("ApprovalId", Rec.NO_);
            Collaborators.SetRange("UserName", UserId);
            if (Collaborators.FindSet()) then isCollaborator := true;
            if (CustomApprovalMgmt.HasApprovalEntriesForCurrentUser(Rec.RecordId)) OR (Rec."Request By" = UserId) OR (isCollaborator) then //AND (Rec.Status <> ApprovalStatus::Open)
                IdFilterString := IdFilterString + Rec.No_ + '|'
        until Rec.Next() = 0;

        if IdFilterString.LastIndexOf('|') > 0 then
            IdFilterString := COPYSTR(IdFilterString, 1, STRLEN(IdFilterString) - 1)
    end;



    var
        IdFilterString: Text;
        StatusStyleTxt: Text;
        ApprovalStatus: Enum "Custom Approval Enum";


}


