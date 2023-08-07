table 50117 cylinder_ddl
{
    Caption = 'cylinder_ddl';
    DataClassification = ToBeClassified;

    fields
    {
        field(3; name; Text[300])
        {
            Caption = 'name';
        }
        field(2; category_id; Integer)
        {
            Caption = 'category_id';
            TableRelation = "cylinder ddl cate";
        }

        field(4; section; Text[20])
        {
            Caption = 'section';
        }
        field(5; name_vn; Text[300])
        {
            Caption = 'Tên tiếng việt';
        }
    }
    keys
    {
        key(PK; name, name_vn)
        {
            Clustered = true;
        }
    }

}
