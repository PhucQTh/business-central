page 50128 DDL
{
    Caption = 'DDL';
    PageType = ListPart;
    SourceTable = cylinder_ddl;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowCaption = false;
                field(name; Rec.name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the name field.';
                }
                field(category_id; Rec.category_id)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the category_id field.';
                    TableRelation = "cylinder ddl cate".id;
                }
                field(display_order; Rec.name_vn)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the display_order field.';
                }
                field(section; Rec.section)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the section field.';
                }
            }
        }
    }
}
