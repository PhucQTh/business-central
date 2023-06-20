page 50112 "Price Approval Request"
{
    Caption = 'Price Approval Request';
    PageType = List;
    SourceTable = "Price Approval";
    CardPageId = "Price Approval";
    UsageCategory = Lists;
    ModifyAllowed = false;
    DeleteAllowed = false;
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
                field("User ID"; Rec.UserName)
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
    trigger OnAfterGetCurrRecord()
    var
        Wf: Codeunit "Custom Workflow Mgmt";
    begin
        StatusStyleTxt := Wf.GetStatusStyleText(Rec);
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
            Rec.SetFilter(Rec.UserName, 'null');
            Rec.FilterGroup := 0;
        end;
    end;

    procedure GetFilterString()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        CustomApprovalMgmt: Codeunit "Custom Workflow Mgmt";
        isCollaborator: Boolean;
    begin
        Rec.FindFirst();

        repeat
            if (ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId)) then
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
