page 50103 MaterialList
{
    ApplicationArea = All;
    Caption = 'MaterialList';
    SourceTable = Material;
    UsageCategory = Documents;
    // CardPageId = "MaterialPage";
    // AutoSplitKey = true;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = true;
    PageType = ListPart;
    layout
    {
        area(content)
        {
            repeater(General)
            {

                field(Item; Rec.Item)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material field.';
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Product code of Manufacturer"; Rec."Product code of Manufacturer")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Product code of Manufacturer field.';
                }
                field(Supplier; Rec.Supplier)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supplier field.';
                }
            }
        }
    }
}
