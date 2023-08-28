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
                    Width = 10;
                }
                field("2"; Rec."2")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_2 field.';
                    Width = 10;
                }
                field("3"; Rec."3")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_3 field.';
                    Width = 10;
                }
                field("4"; Rec."4")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_4 field.';
                    Width = 10;
                }
                field("5"; Rec."5")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_5 field.';
                    Width = 10;
                }
                field("6"; Rec."6")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_6 field.';
                    Width = 10;
                }
                field("7"; Rec."7")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_7 field.';
                    Width = 10;
                }
                field("8"; Rec."8")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_8 field.';
                    Width = 10;
                }
                field("9"; Rec."9")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_9 field.';
                    Width = 10;
                }
                field("10"; Rec."10")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the color_name_10 field.';
                    Width = 10;
                }

            }
        }
    }
}
