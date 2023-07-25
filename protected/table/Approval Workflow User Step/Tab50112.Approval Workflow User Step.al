table 50112 "Approval Workflow User Step"
{
    Caption = 'Approvers';
    DataClassification = ToBeClassified;
    ReplicateData = true;

    fields
    {
        field(1; RequestId; Code[20])
        {
            Caption = 'RequestId';
        }
        field(2; "Sequence No."; Integer)
        {
            Caption = 'Sequence No.';
            MinValue = 1;
        }
        field(3; "User name"; Code[200])
        {
            Caption = 'User name';
            TableRelation = "Approvers List"."User name";

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
                ApproversList: Record "Approval Workflow User Step";
                SequenceNo: Integer;
            begin
                UserSetup.Get("User name");

                if "Sequence No." = 0 then begin
                    SequenceNo := 1;
                    ApproversList.SetCurrentKey(RequestId, "Sequence No.");
                    ApproversList.SetRange(RequestId, RequestId);
                    if ApproversList.FindLast() then
                        SequenceNo := ApproversList."Sequence No." + 1;
                    Validate("Sequence No.", SequenceNo);
                end;
            end;
        }
    }
    keys
    {
        key(Key1; RequestId, "User name")
        {
            Clustered = true;
        }
        key(Key2; RequestId, "Sequence No.", "User name")
        {
        }
    }
}
