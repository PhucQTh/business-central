page 50101 "Test Page"
{
    ApplicationArea = All;
    Caption = 'Test Page';
    PageType = List;
    SourceTable = Test;
    CardPageId = "New Test Page";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(No_; Rec.NO_)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the comment field.';
                }
                field(comment; Rec.comment)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the comment field.';
                }
            }
        }
    }

}
