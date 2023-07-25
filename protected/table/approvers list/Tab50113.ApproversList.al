table 50113 "Approvers List"
{
    Caption = 'Approvers List';
    DataClassification = ToBeClassified;

    fields
    {

        field(2; "User name"; Code[200])
        {
            Caption = 'User name';
            trigger OnValidate()
            var
                UserRec: Record User;
                UserSelect: Codeunit "User Selection";
            begin
                UserSelect.ValidateUserName("User name");
                UserRec.SetRange("User Name", "User name");
                if UserRec.FindFirst() then begin
                    "Full name" := UserRec."Full Name"
                end;
            end;
        }
        field(1; Position; Text[1000])
        {
            Caption = 'Position';
        }
        field(3; Description; Text[1000])
        {
            Caption = 'Description';
        }
        field(4; "Full name"; Text[1000])
        {
            Caption = 'Full name';
        }
    }
    keys
    {

        key(PK1; "User name")
        {
            Clustered = true;
        }
    }
}
