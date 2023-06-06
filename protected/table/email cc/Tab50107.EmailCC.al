table 50107 "Email CC"
{
    Caption = 'Email CC';
    DataClassification = ToBeClassified;
    fields
    {

        field(2; ApprovalID; Code[10])
        {
            Caption = 'ApprovalID';
            DataClassification = ToBeClassified;

        }

        field(4; Email; Text[200])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
        field(3; UserName; Code[50])
        {
            DataClassification = EndUserIdentifiableInformation;
            TableRelation = User."User Name";
            ValidateTableRelation = false;
            trigger OnValidate()
            var
                UserRec: Record User;
                UserSelect: Codeunit "User Selection";
            begin
                UserSelect.ValidateUserName("UserName");
                UserRec.SetRange("User Name", UserName);
                if UserRec.FindFirst() then begin
                    Email := UserRec."Contact Email";
                    "Full name" := UserRec."Full Name"
                end;
            end;

        }
        field(5; "Full name"; Text[80])
        {
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }
    keys
    {
        key(PK; ApprovalID, UserName)
        {
            Clustered = true;
        }
    }
}
