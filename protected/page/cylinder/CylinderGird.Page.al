page 50132 "Cylinder Gird"
{
    Caption = 'Cylinder Gird';
    PageType = ListPart;
    SourceTable = "cylinder info";
    Editable = false;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("No."; Rec."No_")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the No. field.';
                    trigger OnDrillDown()
                    var
                        Selection: Integer;
                        CyinderCard: Page "Cylinder Request Card";
                    begin
                        CyinderCard.SetRecord(Rec);
                        CyinderCard.Run();
                        // if NOT Rec.No_ = '' then
                        //     Rec.Export(true)
                    end;
                }
                field(QCSP; Rec.QCSP)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the QCSP field.';
                }
                field(product_name; Rec.product_name)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the product_name field.';
                }
            }

        }
    }
}
