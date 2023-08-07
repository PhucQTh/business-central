table 50116 "cylinder ddl cate"
{
    Caption = 'cylinder ddl cate';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; id; Integer)
        {
            Caption = 'id';
            AutoIncrement = true;
        }
        field(2; cate_name; Text[300])
        {
            Caption = 'cate_name';
        }
        field(3; cate_name_vn; Text[300])
        {
            Caption = 'cate_name_vn';
        }
    }
    keys
    {
        key(PK; id)
        {
            Clustered = true;
        }
    }
    fieldgroups
    {
        fieldgroup(DropDown; id, cate_name, cate_name_vn) { }
    }
}
