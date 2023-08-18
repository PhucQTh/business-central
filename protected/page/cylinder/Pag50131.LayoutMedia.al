page 50131 LayoutMedia
{
    Caption = 'LayoutMedia';
    PageType = CardPart;
    SourceTable = "cylinder info";

    layout
    {
        area(content)
        {
            group(General)
            {
                ShowCaption = false;

                field(LayoutFile; Rec.LayoutFile)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the LayoutFile field.';
                }
            }
        }
    }
}
