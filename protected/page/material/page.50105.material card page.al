page 50105 MaterialCardPage
{
    Caption = 'MaterialCardPage';
    PageType = Card;
    SourceTable = Material;
    UsageCategory = Lists;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(content)
        {
            group(General)
            {
                grid(topGird)
                {
                    group(left)
                    {
                        ShowCaption = false;
                        field("Product code of Manufacturer"; Rec."Manufacturer's code:")
                        {
                            Caption = 'Product code of Manufacturer';
                            ApplicationArea = All;
                            NotBlank = true;
                            ShowMandatory = true;
                        }
                        field("Supplier"; Rec.Supplier)
                        {
                            Caption = 'Supplier';
                            ApplicationArea = All;
                        }
                        field("Price Term"; Rec."Price Term")
                        {
                            Caption = 'Price Term';
                            ApplicationArea = All;
                            NotBlank = true;
                            ShowMandatory = true;
                        }
                        field(Price; Rec.Price)
                        {
                            Caption = 'Price';
                            ApplicationArea = All;
                            NotBlank = true;
                            ShowMandatory = true;
                        }
                    }
                    group(right)
                    {
                        ShowCaption = false;
                        field("Delivery"; Rec.Delivery)
                        {
                            Caption = 'Delivery';
                            ApplicationArea = All;
                        }
                        field("Pallet/No pallet"; Rec."Pallet/No pallet")
                        {
                            Caption = 'Pallet/No pallet';
                            ApplicationArea = All;
                        }
                        field("Roll length"; Rec."Roll length")
                        {
                            Caption = 'Roll length';
                            ApplicationArea = All;
                        }
                        field("Payment term"; Rec."Payment term")
                        {
                            Caption = 'Payment term';
                            ApplicationArea = All;
                        }
                    }

                }
            }
            group("Price note")
            {
                usercontrol(SMTEditor; "SMT Editor")
                {
                    ApplicationArea = All;
                    trigger ControlAddinReady()
                    begin
                        NewData := Rec.GetContent();
                        CurrPage.SMTEditor.InitializeSummerNote(NewData, 'compact');
                    end;

                    trigger onBlur(Data: Text)
                    begin
                        NewData := Data;
                    end;
                }

            }
            part(Material; "MaterialItemList")
            {
                ApplicationArea = Basic, Suite;
                SubPageLink = "Material No." = FIELD("Line No."), Code = field("Code");
                UpdatePropagation = Both;
            }
        }
    }


    trigger OnOpenPage()
    var
        newRec: Record Material;
    begin
        if isNew = true then begin
            newRec.init;
            newRec.Code := PRID;
            CurrPage.SetRecord(newRec); //! Set record with ID 
            CurrPage.SaveRecord();
        end
    end;
    //! ----------------- Check condition for close page action ----------------- */
    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        ItemRec: Record MaterialItem;
        Result: Boolean;
        Helper: Codeunit "Helper";

    begin
        ItemRec.SetRange("Material No.", Rec."Line No.");
        ItemRec.SetRange("Code", Rec.Code);
        if (Rec.Price = '') OR (Rec.Delivery = '') OR (Rec.Supplier = '') OR (NOT ItemRec.FindSet()) then begin
            Result := Helper.CloseConfirmDialog('Are there any empty fields? Do you want to close without saving?');
            if Result = true then begin
                Rec.Delete();
                exit(true); //!  Close page  
            end;
            exit(false); //! continue page
        end;
        exit(true); //!  Close page 
    end;

    trigger OnClosePage()
    begin
        Rec.SetContent(NewData); //! save data in blob type (PriceNote)
    end;


    trigger OnNextRecord(Steps: Integer): Integer
    begin
        Message('Function is disabled');
    end;

    procedure SetData(data: Code[10]; iisNew: Boolean)
    begin
        PRID := data;
        isNew := iisNew;
    end;

    var
        isNew: Boolean;
        NewData: Text;
        PRID: Code[10];
}
