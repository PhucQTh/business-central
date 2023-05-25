page 50106 MaterialCardPage
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
                            ApplicationArea = All;
                            NotBlank = true;
                            ShowMandatory = true;
                        }
                        field("Supplier"; Rec.Supplier)
                        {
                            ApplicationArea = All;
                        }
                        field("Price Term"; Rec."Price Term")
                        {
                            ApplicationArea = All;
                            NotBlank = true;
                            ShowMandatory = true;
                        }
                        field(Price; Rec.Price)
                        {
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
                            ApplicationArea = All;
                        }
                        field("Pallet/No pallet"; Rec."Pallet/No pallet")
                        {
                            ApplicationArea = All;
                        }
                        field("Roll length"; Rec."Roll length")
                        {
                            ApplicationArea = All;
                        }
                        field("Payment term"; Rec."Payment term")
                        {
                            ApplicationArea = All;
                        }
                    }

                }
            }
            usercontrol(SMTEditor; "SMT Editor")
            {
                ApplicationArea = All;
                trigger ControlAddinReady()
                begin

                    CurrPage.SMTEditor.InitializeSummerNote(Rec."Price Note", 'compact');
                end;

                trigger onBlur(Data: Text)
                begin
                    Rec."Price Note" := Data;
                end;
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
            CurrPage.SetRecord(newRec);
            CurrPage.SaveRecord();
        end
    end;

    trigger OnNextRecord(Steps: Integer): Integer
    begin
        Message('Function is diabled');
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
