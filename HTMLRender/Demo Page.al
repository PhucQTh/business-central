page 50100 "Dynamic HTML Rendering"
{
    Caption = 'Dynamics HTML Rendering';
    UsageCategory = Administration;
    ApplicationArea = all;
    SourceTable = "Material Tree";

    layout
    {
        area(Content)
        {
            usercontrol(html; HTML)
            {
                ApplicationArea = all;
                trigger ControlReady()
                begin
                    //CurrPage.html.Render('<a href="https://www.hougaard.com">A great blog!</a>');
                    CurrPage.html.Render(CreateTable(10, 2));
                end;
            }
        }
    }
    procedure CreateTable(rows: Integer; Columns: Integer): Text
    var
        GL: Record "G/L Account";
        out: Text;
        r, c : Integer;
        RecMaterial: Record "Material Tree";
        lengt: Integer;

    begin
        // GL.FindSet();
        // RecMaterial.FindSet();
        lengt := Rec.Count();
        out := '<table border="1" style="width: 100%;">';
        for r := 1 to lengt do begin
            out += '<tr>';
            out += '<td style="background-color:tomato;">' + Rec."Manufacturer's code:" + '</td>';
            out += '<td style="background-color:powderblue;">' + Rec.Supplier + '</td>';
            RecMaterial.Next();
            out += '</tr>';
        end;
        out += '</table>';
        exit(out);
    end;

    trigger OnInit()
    begin
        LoadOrders();
        Rec.FindFirst();
    end;

    procedure LoadOrders()
    var
        MaterialTreeFunction: Codeunit MaterialTreeFunction;
    begin
        MaterialTreeFunction.CreateMaterialEntries(Rec);
    end;

}