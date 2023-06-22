page 50116 "Services Form"
{
    Caption = 'Services Form';
    PageType = ListPart;
    SourceTable = "Request Purchase Form";

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field(title; Rec.title)
                {
                    Caption = 'Service';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the title field.';
                }
                field(description; Rec.description)
                {
                    Caption = 'Description (detailed of service)';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the description field.';
                }
                field(quantity; Rec.quantity)
                {
                    Caption = 'Quantity';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the quantity field.';
                }
                field(delivery_date; Rec.delivery_date)
                {
                    Caption = 'Date';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the delivery_date field.';
                }
                field(remark; Rec.remark)
                {
                    Caption = 'Remark';
                    ApplicationArea = All;
                    ToolTip = 'Specifies the value of the remark field.';
                }
            }
        }
    }
    actions
    {
        area(Processing)
        {
            action("Import")
            {
                Image = ImportExcel;
                ApplicationArea = all;
                trigger OnAction()
                begin
                    ReadExcelSheet();
                    ImportExcelData()
                end;

            }
        }

    }
    local procedure ReadExcelSheet()
    var
        FileMgt: Codeunit "File Management";
        IStream: InStream;
        FromFile: Text[100];
    begin
        UploadIntoStream(UploadExcelMsg, '', '', FromFile, IStream);
        if FromFile <> '' then begin
            FileName := FileMgt.GetFileName(FromFile);
            SheetName := TempExcelBuffer.SelectSheetsNameStream(IStream);
        end else
            Error(NoFileFoundMsg);
        TempExcelBuffer.Reset();
        TempExcelBuffer.DeleteAll();
        TempExcelBuffer.OpenBookStream(IStream, SheetName);
        TempExcelBuffer.ReadSheet();
    end;

    local procedure ImportExcelData()
    var
        Form: Record "Request Purchase Form";
        RowNo: Integer;
        ColNo: Integer;
        LineNo: Integer;
        MaxRowNo: Integer;
    begin
        RowNo := 0;
        ColNo := 0;
        MaxRowNo := 0;
        LineNo := 0;
        Form.Reset();
        if Form.FindLast() then
            TempExcelBuffer.Reset();
        if TempExcelBuffer.FindLast() then begin
            MaxRowNo := TempExcelBuffer."Row No.";
        end;

        for RowNo := 2 to MaxRowNo do begin
            Form.Init();
            Form.id := Rec.id;
            Form.type := 2;
            Form."Line No." := LineNo;
            Evaluate(Form.title, GetValueAtCell(RowNo, 2));
            Evaluate(Form."Description", GetValueAtCell(RowNo, 3));
            Evaluate(Form."Quantity", GetValueAtCell(RowNo, 4));
            Evaluate(Form.remark, GetValueAtCell(RowNo, 6));
            Form.Insert();
        end;
        Message(ExcelImportSucess);
    end;

    local procedure GetValueAtCell(RowNo: Integer; ColNo: Integer): Text
    begin

        TempExcelBuffer.Reset();
        If TempExcelBuffer.Get(RowNo, ColNo) then
            exit(TempExcelBuffer."Cell Value as Text")
        else
            exit('');
    end;

    var
        BatchName: Code[10];
        FileName: Text[100];
        SheetName: Text[100];

        TempExcelBuffer: Record "Excel Buffer" temporary;
        UploadExcelMsg: Label 'Please Choose the Excel file.';
        NoFileFoundMsg: Label 'No Excel file found!';
        BatchISBlankMsg: Label 'Batch name is blank';
        ExcelImportSucess: Label 'Excel is successfully imported.';
}
