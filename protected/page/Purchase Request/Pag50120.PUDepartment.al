page 50120 "PU Department"
{
    Caption = 'PU Department';
    PageType = ListPart;
    SourceTable = "PU Department";
    ApplicationArea = All;
    UsageCategory = Administration;
    ShowFilter = false;
    layout
    {
        area(content)
        {

            repeater(General)
            {

                field(Employee; Rec.Employee)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Employee field.';
                    Width = 1;
                }
                field("Materials/Services"; Rec."Materials/Services")
                {

                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Materials/Services field.';
                }
            }
        }
    }
}
