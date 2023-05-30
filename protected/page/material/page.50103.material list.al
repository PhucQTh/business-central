page 50103 MaterialList
{
    ApplicationArea = All;
    Caption = 'Material List';
    SourceTable = Material;
    UsageCategory = Documents;
    DelayedInsert = true;
    LinksAllowed = false;
    MultipleNewLines = false;
    PageType = ListPart;
    layout
    {
        area(content)
        {
            repeater(General)
            {
                ShowAsTree = true;

                field(Price; Rec.Price)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price field.';
                    NotBlank = true;
                    ShowMandatory = true;

                }
                field("Product code of Manufacturer"; Rec."Manufacturer's code:")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manufacturer''s code: field.';
                    NotBlank = true;
                    ShowMandatory = true;

                }
                field(Supplier; Rec.Supplier)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supplier field.';
                    ShowMandatory = true;
                }
            }
        }

    }
    actions
    {

        area(Processing)
        {
            // action(NewMaterial)
            // {
            //     Image = New;
            //     Caption = 'Add New Material';
            //     ApplicationArea = All;

            //     trigger OnAction()
            //     var
            //         AddNew: Page "MaterialCardPage";
            //         NewRec: Record "Material";
            //     begin
            //         NewRec.Init();
            //         NewRec.Code := Rec.Code;
            //         AddNew.SetRecord(NewRec);
            //         AddNew.Run();
            //     end;

            // }
        }
    }
}
