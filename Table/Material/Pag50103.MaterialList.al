page 50103 MaterialList
{
    ApplicationArea = All;
    Caption = 'Material List';
    SourceTable = Material;
    UsageCategory = Documents;
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

                field(ItemNo; Rec.ItemNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material field.';
                }
                field(Unit; Rec.Unit)
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
