codeunit 50104 Helper
{
    procedure CloseConfirmDialog(Question: Text): Boolean
    var
        Selected: Boolean;
    begin
        Selected := Dialog.Confirm(Question, false);
        Exit(Selected)
    end;


}
