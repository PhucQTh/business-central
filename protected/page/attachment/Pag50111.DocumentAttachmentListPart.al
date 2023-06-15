page 50111 "Document Attachment ListPart"
{
    Caption = 'Document Attachment ListPart';
    PageType = ListPart;
    SourceTable = "Document Attachment";
    DeleteAllowed = false;
    InsertAllowed = false;
    ModifyAllowed = false;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("File Name"; Rec."File Name")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the filename of the attachment.';
                    trigger OnDrillDown()
                    var
                        Selection: Integer;
                    begin
                        if Rec."Document Reference ID".HasValue() then
                            Rec.Export(true)
                    end;
                }
                field("File Extension"; Rec."File Extension")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the file extension of the attachment.';
                }
                field(User; Rec.User)
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the user who attached the document.';
                }
                field("Attached Date"; Rec."Attached Date")
                {
                    ApplicationArea = All;
                    ToolTip = 'Specifies the date when the document was attached.';
                }
            }
        }
    }

    var
        EmailHasAttachments: Boolean;
        IsOfficeAddin: Boolean;
}
