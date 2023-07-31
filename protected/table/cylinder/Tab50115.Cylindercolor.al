table 50115 "Cylinder-color"
{
    Caption = 'Cylinder-color';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "Type"; Enum CylinderColorTypeEnum)
        {
        }
        field(2; "RequestId"; Code[20])
        {
        }
        field(21; "1"; text[50])
        {
            Caption = '1';
        }
        field(22; "2"; text[50])
        {
            Caption = '2';
        }
        field(23; "3"; text[50])
        {
            Caption = '3';
        }
        field(24; "4"; text[50])
        {
            Caption = '4';
        }
        field(25; "5"; text[50])
        {
            Caption = '5';
        }
        field(26; "6"; text[50])
        {
            Caption = '6';
        }
        field(27; "7"; text[50])
        {
            Caption = '7';
        }
        field(28; "8"; text[50])
        {
            Caption = '8';
        }
        field(29; "9"; text[50])
        {
            Caption = '9';
        }
        field(30; "10"; text[50])
        {
            Caption = '10';
        }


    }
    keys
    {
        key(PK; "Type", "RequestId")
        {
            Clustered = true;
        }
    }
}
ENUM 50104 CylinderColorTypeEnum
{
    value(1; Color)
    {
        Caption = 'Color';
    }
    value(2; Cylinder)
    {
        Caption = 'Cylinder';
    }
}