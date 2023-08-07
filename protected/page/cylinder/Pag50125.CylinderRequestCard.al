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
                    }

                    field(QCSP; Rec.QCSP)
                    {
                        ApplicationArea = All;
                    }
                    field("PTLT"; Rec.cylinder_status)
                    {
                        Caption = 'Cylinder Status';
                        ApplicationArea = All;
                        TableRelation = cylinder_ddl.name where(category_id = filter(= 2));
                    }
                    field("Loai truc in"; Rec.cylinder_type)
                    {
                        Caption = 'Cylinder Type';
                        ApplicationArea = All;
                        TableRelation = cylinder_ddl.name where(category_id = filter(= 3));
                    }
                    field(size_perimeter; Rec.size_perimeter)
                    {
                        Caption = 'Size Perimeter (mm)';
                        ApplicationArea = All;
                    }
                    field(print_material; Rec.print_material)
                    {
                        Caption = 'Print Material';
                        ApplicationArea = All;
                    }
                    field(company_logo; Rec.company_logo)
                    {
                        Caption = 'Logo ACCA';
                        ApplicationArea = All;
                    }
                }
                group(b)
                {
                    ShowCaption = false;

                    field("NCC"; Rec.supplier)
                    {
                        Caption = 'Supplier';
                        ApplicationArea = All;
                        TableRelation = cylinder_ddl.name where(category_id = filter(= 1));
                    }
                    field("Product Name"; Rec.product_name)
                    {
                        Caption = 'Product Name';
                        ApplicationArea = All;
                    }

                    field(quantity; Rec.quantity)
                    {
                        Caption = 'Quantity';
                        ApplicationArea = All;
                    }

                    field(cylinder_type_other; Rec.cylinder_type_other)
                    {
                        Caption = 'Cylinder Type Other';
                        ApplicationArea = All;
                    }
                    field(ink_type; Rec.ink_type)
                    {
                        Caption = 'Ink Type';
                        ApplicationArea = All;
                    }
                    grid(size)
                    {
                        field(size_length; Rec.size_length)
                        {
                            Caption = 'Size Length (mm)';
                            ApplicationArea = All;
                        }
                        field(size_note; Rec.size_note)
                        {
                            Caption = 'Size Note';
                            ApplicationArea = All;
                        }
                    }
                    grid(film)
                    {
                        field(film_size; Rec.film_size)
                        {
                            Width = 50;
                            Caption = 'Film Size (mm)';
                            ApplicationArea = All;
                        }
                        field("Print Area"; Rec.print_area)
                        {
                            Caption = 'Print Area';
                            ApplicationArea = All;
                            TableRelation = cylinder_ddl.name where(category_id = filter(= 4));
                        }
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
                        Caption = 'Proof';
                    }
                    field(File; Rec.effective_file)
                    {
                        ApplicationArea = All;
                        Caption = 'File';
                    }
                    field("Sample bag"; Rec.effective_sample_bag)
                    {
                        ApplicationArea = All;
                        Caption = 'Sample bag';
                    }
                    field(OtherCheck; Rec.effective_other)
                    {
                        Caption = 'Other';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field(effective_other_value; Rec.effective_other_value)
                    {
                        Enabled = Rec.effective_other;
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                }
            }
            group(Color_Group)
            {
                ShowCaption = false;
                part(Color; "Cylinder Color")
                {
                    ApplicationArea = All;
                    SubPageLink = RequestId = field("No_");
                }
            }
            group(Product_size)
            {
                field(product_width; Rec.product_width)
                {
                    Caption = 'Width (mm):';
                    ApplicationArea = All;
                }
                field(product_height; Rec.product_height)
                {
                    Caption = 'Height (mm):';
                    ApplicationArea = All;
                }
                field(page_number_width; Rec.page_number_width)
                {
                    Caption = 'Page Width:';
                    ApplicationArea = All;
                }
                field(page_number_height; Rec.page_number_height)
                {
                    Caption = 'Page Height:';
                    ApplicationArea = All;
                }
            }

            part("Attached Documents List"; "Document Attachment ListPart")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50114),
                              "No." = FIELD("No_");
            }
            group("Other Request")
            {
                usercontrol(SMTEditor; "SMT Editor")
                {
                    ApplicationArea = All;
                    trigger ControlAddinReady()
                    begin
                        CurrPage.SMTEditor.InitializeSummerNote(Rec.other_note, 'compact');
                    end;

                    trigger onBlur(Data: Text)
                    begin
                        Rec.other_note := Data;
                    end;
                }

            }
            part(Approvers; ApproversChoice)
            {
                // Editable = DynamicEditable;
                Caption = 'Approvers';
                ApplicationArea = All;
                SubPageLink = RequestId = field("No_");
            }
            part(Collaborators; EmailCC)
            {
                // Editable = DynamicEditable;
                Caption = 'Collaborators';
                ApplicationArea = All;
                SubPageLink = ApprovalID = field("No_");
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    var
        ColorCylinderRec: Record "Cylinder-color";
        TypeEnum: Enum CylinderColorTypeEnum;
    begin
        if (Rec.No_ = '') then begin
            Rec.company_logo := true;
            CurrPage.Update(true);
            ColorCylinderRec.RequestId := Rec.No_;
            ColorCylinderRec.Type := TypeEnum::Color;
            ColorCylinderRec.Insert();
            ColorCylinderRec.RequestId := Rec.No_;
            ColorCylinderRec.Type := TypeEnum::Cylinder;
            ColorCylinderRec.Insert();
        end;

    end;

    var
        NCC: Text;
        OtherCheck: Boolean;
}
