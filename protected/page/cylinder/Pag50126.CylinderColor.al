page 50126 "Cylinder Color"
{
    Caption = 'Cylinder Color';
    PageType = ListPart;
    SourceTable = "Cylinder-color";
    DeleteAllowed = false;
    InsertAllowed = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Type"; Rec."Type")
                {
                    ShowCaption = false;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Type field.';
                    Editable = false;

                }
                field("1"; Rec."1")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_1 field.';
                }
                field("2"; Rec."2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_2 field.';
                }
                field("3"; Rec."3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_3 field.';
                }
                field("4"; Rec."4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_4 field.';
                }
                field("5"; Rec."5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_5 field.';
                }
                field("6"; Rec."6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_6 field.';
                }
                field("7"; Rec."7")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_7 field.';
                }
                field("8"; Rec."8")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_8 field.';
                }
                field("9"; Rec."9")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_9 field.';
                }
                field("10"; Rec."10")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_10 field.';
                }

            }
        }
    }
}
