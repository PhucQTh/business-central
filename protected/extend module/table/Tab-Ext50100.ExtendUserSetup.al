tableextension 50100 "Extend User Setup" extends "User Setup"
{
    fields
    {
        field(50100; "Allow view price approval"; Boolean)
        {
            Caption = 'Allow view price approval';
            DataClassification = CustomerContent;
        }
        field(50101; Department; Code[50])
        {
            Caption = 'Department';
            DataClassification = ToBeClassified;
        }
    }
}
