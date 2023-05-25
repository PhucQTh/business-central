page 50100 "Material Html Rendering"
{
    Caption = 'Material';
    UsageCategory = Administration;
    ApplicationArea = all;
    SourceTable = "Material Tree";
    PageType = ListPart;
    InsertAllowed = false;
    ModifyAllowed = false;
    DeleteAllowed = false;
    layout
    {
        area(Content)
        {
            field(addNewBtn; AddNewBtnLbl)
            {
                ApplicationArea = All;
                ShowCaption = false;
                StyleExpr = 'Strong';
                trigger OnDrillDown()
                var
                    AddNew: Page "MaterialCardPage";
                begin
                    AddNew.SetData(PRID, true);
                    if AddNew.RunModal() = Action::OK then
                        Render(true);
                end;
            }
            usercontrol(html; HTML)
            {

                ApplicationArea = all;
                trigger ControlReady()
                begin
                    Render(false);
                end;

                trigger handleEditBtn(LineNo: Integer)
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
                        Render(true);
                    end;

                end;

                trigger handleDelBtn(LineNo: Integer)
                var
                    materialRec: Record "Material";
                    Text000: Label 'Are you want to delete %1?';
                    Answer: Boolean;
                    Question: Text;
                begin
                    materialRec.SetRange("Line No.", LineNo);
                    materialRec.SetRange("Code", PRID);
                    if materialRec.FindFirst() then begin

                        Question := Text000;
                        Answer := Dialog.Confirm(Question, true, materialRec."Manufacturer's code:");
                        if Answer = true then begin
                            if materialRec.Delete() then begin
                                Render(true);
                            end;
                        end
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
        Rec.FindFirst();
        if Rec.Count() > 0 then begin
            stt := 1;
            out := '<table class="table table-sm table-bordered fs-6">';
            repeat
                if (Rec.Indentation = 1) then begin
                    #region TbItem
                    out += '<tr><td>' + Rec.ItemNo + '</td><td colspan="4">' + Rec.Description + '</td><td colspan="2">' + Rec.Quantity + '</td> <td>' + Rec.Unit + '</td></tr>';
                    #endregion TbItem
                end;
                if Rec.Indentation = 0 then begin
                    #region TBinfo
                    if stt > 1 then out += '</tbody>';
                    out += '<tr><td colspan="8"></td><tr>';//! spacing bettwen 2 suplier 
                    out += '<tr class="table-primary text text-center table-borderless" >';//! Header row
                    out += '<td colspan="7">Material ' + Format(stt) + '</td>';
                    out += '<td><div id="btn-placerholder-' + Format(Rec."Line No.") + '" class ="btn-group"></div></td>'; //! Button group placeHolder
                    out += '</tr>';
                    out += '<tr>';
                    out += '<td class="table-secondary"><label class="control-label">Product code of Manufacturer:</label></td>';
                    out += '<td class="special">' + Rec."Manufacturer's code:" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Price:</label></td>';
                    out += '<td class="special" ">' + Rec.Price + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Delivery:</label></td>';
                    out += '<td >' + Rec.Delivery + '</td>';
                    out += '<td class="table-secondary" ><label class="control-label">Roll length:</label></td>';
                    out += '<td >' + Rec."Roll length" + '</td>';
                    out += '</tr>';
                    out += '<tr>';
                    out += '<td class="table-secondary"><label class="control-label">Supplier:</label></td>';
                    out += '<td>' + Rec.Supplier + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Payment term:</label></td>';
                    out += '<td>' + Rec."Payment term" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Pallet/No pallet:</label></td>';
                    out += '<td>' + Rec."Pallet/No pallet" + '</td>';
                    out += '<td class="table-secondary"><label class="control-label">Payment term:</label></td>';
                    out += '<td>' + Rec."Payment term" + '</td>';
                    out += '</tr>';
                    out += '<tr> <td class="table-secondary">Price note</td> <td colspan="7">' + Rec."Price Note" + '</td></tr>';
                    out += '<tbody class="table-group-divider">';
                    out += '<tr class="table-info"><td>Mtl code</td><td colspan="4">Material name</td><td colspan="2">Quantity</td> <td>Unit</td> </tr>';
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
        Rec.FindFirst();
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
    end;

    procedure Render(reload: Boolean)
    begin
        LoadOrders();
        if Rec.Count > 0 then begin
            CurrPage.html.Render(CreateTable(), reload);
            CreateButton();
        end;
        if Rec.Count <= 0 then
            CurrPage.html.Render('<p name="lable-for-null">PLEASE ADD MATERIAL</p>', reload);
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
        AddNewBtnLbl: Label 'ADD NEW MATERIAL';
        PRID: Code[10];

}