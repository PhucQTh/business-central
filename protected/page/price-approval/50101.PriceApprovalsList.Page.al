page 50101 "Price Approvals"
{
    ApplicationArea = All;
    Caption = 'Price Approvals';
    PageType = List;
    SourceTable = "Price Approval";
    CardPageId = "Price Approval";
    UsageCategory = Lists;
    ShowFilter = false;
    ModifyAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
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
                Promoted = true;
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
    }


    trigger OnOpenPage()
    var
        UserSetup: Record "User Setup";
        filteredRec: Record "Price Approval" temporary;
    begin
        GetFilterString();
        if (IdFilterString <> '')
      then begin
            Rec.FilterGroup := 100;
            Rec.SetFilter(Rec.No_, IdFilterString);
            Rec.FilterGroup := 0;
        end
        else begin
            Rec.FilterGroup := 100;
            Rec.SetFilter(Rec.UserName, UserId);
            Rec.FilterGroup := 0;
        end;
    end;

    procedure GetFilterString()
    var
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        Collaborators: Record "Email CC";
        isCollaborator: Boolean;
    begin
        Rec.FindFirst();

        repeat
            isCollaborator := false;
            Collaborators.SetRange("ApprovalId", Rec.NO_);
            Collaborators.SetRange("UserName", UserId);
            // Message(Rec.No_ + ': ' + Rec.Title);s
            if (Collaborators.FindSet()) then isCollaborator := true;
            if (ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId)) OR (Rec.UserName = UserId) OR (isCollaborator) then
                IdFilterString := IdFilterString + Rec.No_ + '|'
        until Rec.Next() = 0;

        if IdFilterString.LastIndexOf('|') > 0 then
            IdFilterString := COPYSTR(IdFilterString, 1, STRLEN(IdFilterString) - 1)
    end;

    var
        IdFilterString: Text;

}


