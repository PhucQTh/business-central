page 50100 "Material Html Rendering"
{
    Caption = 'Material';
    UsageCategory = Administration;
    ApplicationArea = all;
    SourceTable = "Material Tree";
    PageType = ListPart;

    layout
    {
        area(Content)
        {
            usercontrol(html; HTML)
            {
                ApplicationArea = all;
                trigger ControlReady()
                begin
                    CurrPage.html.Render(CreateTable());
                    CreateButton();
                end;

                trigger ButtonPressed(LineNo: Integer)
                var
                    AddNew: Page "MaterialCardPage";
                    materialRec: Record "Material";
                begin
                    materialRec."Line No." := LineNo;
                    materialRec.Code := PRID;
                    if materialRec.Find('=') then begin
                        AddNew.SetRecord(materialRec);
                        AddNew.RunModal();
                        LoadOrders();
                    end;

                end;
            }
        }
    }


    procedure CreateTable(): Text
    var
        out: Text;
        stt: Integer;
    begin
        if Rec.Count() > 0 then begin
            stt := 1;
            out := '<table class="table table-sm table-bordered fs-6">';
            repeat
                if (Rec.Indentation = 1) then begin
                    #region TbItem
                    out += '<tr><td>' + Rec.ItemNo + '</td><td colspan="4">' + Rec.Description + '</td><td colspan="2">' + Rec.Quantity + '</td> <td>' + Rec.Unit + '</td></tr>';
                    out += '</tbody>';
                    #endregion TbItem
                end;
                if Rec.Indentation = 0 then begin
                    #region TBinfo
                    out += '<tr class="table-primary text text-center"><td colspan="7">Material ' + Format(stt) + '</td><td id="btn-placerholder-' + Format(Rec."Line No.") + '"></tr><tr>';
                    out += '<td class="table-secondary"><label class="control-label">Product code of Manufacturer:</label></td>';
                    out += '<td width="100" class="special">' + Rec."Manufacturer's code:" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Price:</label></td>';
                    out += '<td class="special" width="160">' + Rec.Price + '</td>';
                    out += '<td class="table-secondary" width="105"><label class="control-label">Delivery:</label></td>';
                    out += '<td width="143">' + Rec.Delivery + '</td>';
                    out += '<td class="table-secondary" width="100"><label class="control-label">Roll length:</label></td>';
                    out += '<td width="126">' + Rec."Roll length" + '</td>';
                    out += '</tr>';
                    out += '<tr>';
                    out += '<td class="table-secondary"><label class="control-label">Supplier:</label></td>';
                    out += '<td>' + Rec.Supplier + '</td>';
                    out += '<td class="table-secondary" width="60"><label class="control-label">Payment term:</label></td>';
                    out += '<td>' + Rec."Payment term" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Pallet/No pallet:</label></td>';
                    out += '<td>' + Rec."Pallet/No pallet" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Payment term:</label></td>';
                    out += '<td>' + Rec."Payment term" + '</td>';
                    out += '</tr>';
                    out += '<tr> <td class="table-secondary">Price note</td> <td colspan="7">' + Rec."Price Note" + '</td></tr>';
                    out += '<tbody class="table-group-divider">';
                    out += '<tr class="table-secondary"><td>Mtl code</td><td colspan="4">Material name</td><td colspan="2">Quantity</td> <td>Unit</td> </tr>';
                    #endregion TBinfo
                    stt += 1;
                end;
            until Rec.Next() = 0;
        end;
        out += '</table>';
        exit(out);

    end;

    procedure CreateButton()
    begin
        Rec.FindFirst(); //! RESET REC INTO THE FIRST POSITION
        if Rec.Count() > 0 then begin
            repeat
                if Rec.Indentation = 0 then begin
                    CurrPage.html.addButton(Rec."Line No.");
                end until Rec.Next() = 0;

        end;
    end;


    trigger OnOpenPage()
    begin
        LoadOrders();
        Rec.FindFirst();
        Rec.Find('=');
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