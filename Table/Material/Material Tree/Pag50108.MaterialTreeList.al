page 50108 MaterialTreeList
{
    Caption = 'Materials';
    PageType = ListPart;
    SourceTable = "Material Tree";
    Editable = false;
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                IndentationColumn = Rec.Indentation;
                ShowAsTree = true;
                field(Indentation; Rec.Indentation)
                {
                    ToolTip = 'Specifies the value of the Level field.';
                    ApplicationArea = All;
                    Visible = false;
                    Editable = false;
                }

                field("Manufacturer's code:"; Rec."Manufacturer's code:")
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Manufacturer''s code: field.';
                }
                field(Supplier; Rec.Supplier)
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Supplier field.';
                }
                field("Roll length"; Rec."Roll length")
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Term field.';
                }
                field("Pallet/No pallet"; Rec."Pallet/No pallet")
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Pallet/No pallet field.';
                }
                field("Payment term"; Rec."Payment term")
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment term field.';
                }
                field(Price; Rec.Price)
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price field.';
                }
                field("Price Note"; Rec."Price Note")
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Payment term field.';
                }
                field("Price Term"; Rec."Price Term")
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Price Term field.';
                }
                field(Delivery; Rec.Delivery)
                {
                    StyleExpr = StyleExpr;
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Delivery field.';
                }
                field(ItemNo; Rec.ItemNo)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Material field.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Description field.';
                }
                field(Unit; Rec.Unit)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Unit field.';
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the Quantity field.';
                }
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Open)
            {
                ApplicationArea = all;
                Caption = 'Open document';
                trigger OnAction()
                var
                    Material: Record Material;
                    MaterialPage: Page "MaterialCardPage";
                begin
                    Material.SetRange("Code", Rec."Code");
                    Material.SetRange("Line No.", Rec."Line No.");
                    if Material.FindFirst() then begin
                        MaterialPage.SetRecord(Material);
                        MaterialPage.RunModal();
                        LoadOrders();
                    end;
                end;

            }
            action(NewMaterial)
            {
                Image = New;
                Caption = 'Add New Material';
                ApplicationArea = All;

                trigger OnAction()
                var
                    AddNew: Page "MaterialCardPage";
                    NewRec: Record "Material";
                begin

                    NewRec.Init();
                    NewRec.Code := PRID;
                    NewRec.Insert();
                    AddNew.SetRecord(NewRec);
                    AddNew.Run();
                    Rec.Find('=')
                end;

            }

        }
    }
    trigger OnAfterGetRecord()
    begin
        case Rec.Indentation of
            0:
                begin
                    HideValues := false;
                    StyleExpr := 'Strong';
                end;
            1:
                begin
                    HideValues := true;
                end;
        end;
    end;

    procedure CodeFillter(PACode: Code[10])
    begin
        Rec.SetRange("Code", PACode);
        CurrPage.SetTableView(Rec);
        CurrPage.Update();
    end;

    // trigger OnInit()
    // begin
    //     LoadOrders();
    //     Rec.FindFirst();
    //     Rec.Find('=');
    // end;

    trigger OnOpenPage()
    begin
        LoadOrders();
    end;

    procedure LoadOrders()
    var
        MaterialTreeFunction: Codeunit MaterialTreeFunction;
    begin
        MaterialTreeFunction.CreateMaterialEntries(Rec,
        PRID);
    end;


    procedure SetData(data: Code[10])
    begin
        PRID := data;
    end;

    var
        HideValues: Boolean;
        StyleExpr: Text;
        PRID: Code[10];
}