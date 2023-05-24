page 50107 MaterialItemList
{
    ApplicationArea = All;
    Caption = 'Material Item List';
    SourceTable = MaterialItem;
    UsageCategory = Documents;
    DelayedInsert = true;
    LinksAllowed = false;

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
                    ShowMandatory = true;

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
                    NotBlank = true;
                    ShowMandatory = true;

                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material field.';
                    NotBlank = true;
                    ShowMandatory = true;

                }

            }
        }

    }
    actions
    {


    }
}
