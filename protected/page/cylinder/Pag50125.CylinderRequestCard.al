page 50125 "Cylinder Request Card"
{
    Caption = 'Cylinder Request Card';
    PageType = Card;
    SourceTable = "cylinder info";

    layout
    {
        area(content)
        {
            grid(aa)
            {
                ShowCaption = false;

                group(a)
                {
                    ShowCaption = false;

                    field("Date"; 'date')
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the QCSP field.';
                    }

                    field(QCSP; Rec.QCSP)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the QCSP field.';
                    }
                    field("PTLT"; 'PTLT')
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the QCSP field.';
                    }
                    field("Loai truc in"; 'Loai truc in')
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the QCSP field.';
                    }
                    field(size_perimeter; Rec.size_perimeter)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the size_perimeter field.';
                    }
                    field(print_material; Rec.print_material)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the size_perimeter field.';
                    }
                }
                group(b)
                {
                    ShowCaption = false;

                    field("NCC"; 'NCC')
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the QCSP field.';
                    }
                    field("Product Name"; Rec.product_name)
                    {
                        Caption = 'Product Name';
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the QCSP field.';
                    }

                    field(quantity; Rec.quantity)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the quantity field.';
                    }

                    field(cylinder_type_other; Rec.cylinder_type_other)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the cylinder_type_other field.';
                    }
                }

            }
            group("Effective by")
            {
                grid(c)
                {
                    field(Proof; Rec.effective_proof)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the effective_other_value field.';
                        Caption = 'Proof';
                    }
                    field(File; Rec.effective_file)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the effective_other_value field.';
                        Caption = 'File';
                    }
                    field("Sample bag"; Rec.effective_sample_bag)
                    {
                        ApplicationArea = All;
                        ToolTip = 'Specifies the value of the effective_other_value field.';
                        Caption = 'Sample bag';
                    }
                    group(Other)
                    {

                        field(OtherCheck; Rec.effective_other)
                        {
                            ShowCaption = false;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the effective_other_value field.';
                        }
                        field(effective_other_value; Rec.effective_other_value)
                        {
                            Visible = Rec.effective_other;
                            ShowCaption = false;
                            ApplicationArea = All;
                            ToolTip = 'Specifies the value of the effective_other_value field.';
                        }

                    }
                }
            }
            group(Color_Group)
            {
                ShowCaption = false;
                part(Color; "Cylinder Color")
                {
                    ApplicationArea = All;
                    SubPageLink = RequestId = field("No.");
                }
            }

        }
    }
    trigger OnNewRecord(BelowxRec: Boolean)
    var
        ColorCylinderRec: Record "Cylinder-color";
        TypeEnum: Enum CylinderColorTypeEnum;
    begin
        ColorCylinderRec.Type := TypeEnum::Color;
        ColorCylinderRec.Insert();
        ColorCylinderRec.Type := TypeEnum::Cylinder;
        ColorCylinderRec.Insert();
    end;
}
