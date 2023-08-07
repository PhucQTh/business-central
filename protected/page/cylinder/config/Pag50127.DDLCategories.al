page 50127 "DDL Categories"
{
    Caption = 'DDL Categories';
    PageType = ListPart;
    SourceTable = "cylinder ddl cate";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(cate_name; Rec.cate_name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the cate_name field.';
                }
                field(cate_name_vn; Rec.cate_name_vn)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the cate_name_vn field.';
                }

            }
        }
    }
}
