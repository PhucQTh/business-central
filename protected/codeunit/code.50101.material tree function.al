codeunit 50101 MaterialTreeFunction
{
    procedure DeleteMaterialEntries(lineNo: Integer; PRID: Code[10]) Data: Boolean
    var
        materialItemList: Record "MaterialItem";
        materialRec: Record "Material";
    begin
        materialRec.SetRange("Code", PRID);
        if (lineNo > 0) then
            materialRec.SetRange("Line No.", LineNo);
        if materialRec.FindSet() then begin
            materialItemList.SetRange("Code", materialRec.Code);
            materialItemList.SetRange("Material No.", materialRec."Line No.");
            if (materialItemList.FindSet()) then
                materialItemList.DeleteAll();
            if (lineNo > 0) then materialRec.DeleteAll();
            materialRec.Delete();
            Data := true;
            exit;
        end;
        Data := false;
    end;

    procedure CreateMaterialEntries(var rlMaterialTree: Record "Material Tree"; var PAid: Code[10])
    var
        MSupplier: Record "Material";
    begin
        rlMaterialTree.DeleteAll();
        MSupplier.SetRange("Code", PAid);
        if MSupplier.FindFirst() then begin
            repeat
                CreateLevel0(MSupplier, rlMaterialTree);
                CreateLevel1(MSupplier, rlMaterialTree);
            until MSupplier.Next() = 0;
        end;
    end;


    local procedure CreateLevel0(MSupplier: Record "Material"; var rlMaterialTree: Record "Material Tree")
    begin
        rlMaterialTree.Init();
        rlMaterialTree."Entry No." := EntryNo;
        rlMaterialTree.Indentation := 0;
        rlMaterialTree."Manufacturer's code:" := MSupplier."Manufacturer's code:";
        rlMaterialTree.Supplier := MSupplier.Supplier;
        rlMaterialTree.Delivery := MSupplier.Delivery;
        rlMaterialTree."Pallet/No pallet" := MSupplier."Pallet/No pallet";
        rlMaterialTree."Roll length" := MSupplier."Roll length";
        rlMaterialTree."Payment term" := MSupplier."Payment term";
        rlMaterialTree.Price := MSupplier.Price;
        rlMaterialTree.SetContent(MSupplier.GetContent());
        // Message(MSupplier.GetContent());
        rlMaterialTree."Price Term" := MSupplier."Price Term";
        rlMaterialTree.Code := MSupplier.Code;
        rlMaterialTree."Line No." := MSupplier."Line No.";
        rlMaterialTree.Insert();
        EntryNo += 1;
    end;

    local procedure CreateLevel1(MSupplier: Record "Material"; var rlMaterialTree: Record "Material Tree")
    var
        MaterialItem: Record "MaterialItem";
    begin
        MaterialItem.SetRange("Code", MSupplier.Code);
        MaterialItem.SetRange("Material No.", MSupplier."Line No.");
        if MaterialItem.FindSet() then begin
            repeat
                rlMaterialTree.Init();
                rlMaterialTree."Entry No." := EntryNo;
                rlMaterialTree.Indentation := 1;
                rlMaterialTree."Code" := MSupplier.Code;
                rlMaterialTree."Line No." := MSupplier."Line No.";
                rlMaterialTree.ItemNo := MaterialItem.ItemNo;
                rlMaterialTree.Description := MaterialItem.Description;
                rlMaterialTree.Unit := MaterialItem.Unit;
                rlMaterialTree.Quantity := MaterialItem.Quantity;
                rlMaterialTree.Insert();
                EntryNo += 1;
            until MaterialItem.Next() = 0;
        end;
    end;
    //! EVENT


    var
        EntryNo: Integer;
}
