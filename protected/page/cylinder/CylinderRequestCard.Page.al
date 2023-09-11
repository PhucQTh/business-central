page 50125 "Cylinder Request Card"
{
    Caption = 'Cylinder Request Card';
    PageType = Card;
    SourceTable = "cylinder info";

    layout
    {
        area(content)
        {
            grid(aa)
            {
                ShowCaption = false;

                group(a)
                {
                    ShowCaption = false;

                    field("Date"; 'date')
                    {
                        ApplicationArea = All;
                    }

                    field(QCSP; Rec.QCSP)
                    {
                        ApplicationArea = All;
                    }
                    field("PTLT"; Rec.cylinder_status)
                    {
                        Caption = 'Cylinder Status';
                        ApplicationArea = All;
                        TableRelation = cylinder_ddl.name where(category_id = filter(= 2));
                    }
                    field("Loai truc in"; Rec.cylinder_type)
                    {
                        Caption = 'Cylinder Type';
                        ApplicationArea = All;
                        TableRelation = cylinder_ddl.name where(category_id = filter(= 3));
                    }
                    field(size_perimeter; Rec.size_perimeter)
                    {
                        Caption = 'Size Perimeter (mm)';
                        ApplicationArea = All;
                    }
                    field(print_material; Rec.print_material)
                    {
                        Caption = 'Print Material';
                        ApplicationArea = All;
                    }
                    field(company_logo; Rec.company_logo)
                    {
                        Caption = 'Logo ACCA';
                        ApplicationArea = All;
                    }
                }
                group(b)
                {
                    ShowCaption = false;

                    field("NCC"; Rec.supplier)
                    {
                        Caption = 'Supplier';
                        ApplicationArea = All;
                        TableRelation = cylinder_ddl.name where(category_id = filter(= 1));
                    }
                    field("Product Name"; Rec.product_name)
                    {
                        Caption = 'Product Name';
                        ApplicationArea = All;
                    }

                    field(quantity; Rec.quantity)
                    {
                        Caption = 'Quantity';
                        ApplicationArea = All;
                    }

                    field(cylinder_type_other; Rec.cylinder_type_other)
                    {
                        Caption = 'Cylinder Type Other';
                        ApplicationArea = All;
                    }
                    field(ink_type; Rec.ink_type)
                    {
                        Caption = 'Ink Type';
                        ApplicationArea = All;
                    }
                    grid(size)
                    {
                        field(size_length; Rec.size_length)
                        {
                            Caption = 'Size Length (mm)';
                            ApplicationArea = All;
                        }
                        field(size_note; Rec.size_note)
                        {
                            Caption = 'Size Note';
                            ApplicationArea = All;
                        }
                    }
                    grid(film)
                    {
                        field(film_size; Rec.film_size)
                        {
                            Width = 50;
                            Caption = 'Film Size (mm)';
                            ApplicationArea = All;
                        }
                        field("Print Area"; Rec.print_area)
                        {
                            Caption = 'Print Area';
                            ApplicationArea = All;
                            TableRelation = cylinder_ddl.name where(category_id = filter(= 4));
                        }
                    }
                }
            }
            group("Effective by")
            {
                grid(c)
                {
                    field(Proof; Rec.effective_proof)
                    {
                        ApplicationArea = All;
                        Caption = 'Proof';
                    }
                    field(File; Rec.effective_file)
                    {
                        ApplicationArea = All;
                        Caption = 'File';
                    }
                    field("Sample bag"; Rec.effective_sample_bag)
                    {
                        ApplicationArea = All;
                        Caption = 'Sample bag';
                    }
                    field(OtherCheck; Rec.effective_other)
                    {
                        Caption = 'Other';
                        ApplicationArea = All;
                        trigger OnValidate()
                        begin
                            CurrPage.Update();
                        end;
                    }
                    field(effective_other_value; Rec.effective_other_value)
                    {
                        Enabled = Rec.effective_other;
                        ShowCaption = false;
                        ApplicationArea = All;
                    }
                }
            }
            group(Color_Group)
            {
                ShowCaption = false;
                part(Color; "Cylinder Color")
                {
                    ApplicationArea = All;
                    SubPageLink = RequestId = field("No_");
                }
            }
            group(Product_size)
            {
                field(product_width; Rec.product_width)
                {
                    Caption = 'Width (mm):';
                    ApplicationArea = All;
                }
                field(product_height; Rec.product_height)
                {
                    Caption = 'Height (mm):';
                    ApplicationArea = All;
                }
                field(page_number_width; Rec.page_number_width)
                {
                    Caption = 'Page Width:';
                    ApplicationArea = All;
                }
                field(page_number_height; Rec.page_number_height)
                {
                    Caption = 'Page Height:';
                    ApplicationArea = All;
                }
            }

            part("Attached Documents List"; "Document Attachment ListPart")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(50114),
                              "No." = FIELD("No_");

            }

            usercontrol(LayoutImageViewer; HTML)
            {
                ApplicationArea = All;
                trigger ControlReady()
                var
                    InStr: InStream;
                    ImgBase64: Text;
                    Helper: Codeunit Helper;
                begin
                    if Rec.LayoutFile.Count > 0 then
                        ImgBase64 := Helper.ItemTenantMediaToBase64(Rec.LayoutFile.Item(1));
                    CurrPage.LayoutImageViewer.Render('<div style="display: flex;align-items: center;;flex-direction: column"><h6>LAYOUT</h6><img src="data:image/png;base64,' + ImgBase64 + '" alt="printlayout" style="width: 500px;height: 376px; object-fit: contain;"/></div>', false);
                end;
            }
            group("Other Request")
            {
                usercontrol(SMTEditor; "SMT Editor")
                {
                    ApplicationArea = All;
                    trigger ControlAddinReady()
                    begin
                        CurrPage.SMTEditor.InitializeSummerNote(Rec.other_note, 'compact');
                    end;

                    trigger onBlur(Data: Text)
                    begin
                        Rec.other_note := Data;
                    end;
                }

            }
            part(Approvers; ApproversChoice)
            {
                // Editable = DynamicEditable;
                Caption = 'Approvers';
                ApplicationArea = All;
                SubPageLink = RequestId = field("No_");
            }
            part(Collaborators; EmailCC)
            {
                // Editable = DynamicEditable;
                Caption = 'Collaborators';
                ApplicationArea = All;
                SubPageLink = ApprovalID = field("No_");
            }
        }

    }
    actions
    {
        area(Processing)
        {
            group(Approval)
            {
                Image = Approvals;
                action(onHold)
                {
                    Caption = 'On Hold';
                    ApplicationArea = All;
                    Image = Answers;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistCurrUser AND (Rec.Status <> P::OnHold);
                    trigger OnAction()
                    var
                        Response: Codeunit MyWorkflowResponses;
                    begin
                        // Rec.Status := p::OnHold;
                        Rec.Modify();
                        Response.SentOnHoldEmail(UserId, Rec.RecordId);
                    end;
                }
                action(Approve)
                {
                    ApplicationArea = All;
                    Caption = 'Approve';
                    Image = Approve;
                    ToolTip = 'Approve the requested.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Visible = OpenApprovalEntriesExistCurrUser;
                    trigger OnAction()
                    var
                        Question: Text;
                        Answer: Boolean;
                        Text000: Label 'Do you agree with this request?';
                    begin
                        Question := Text000;
                        Answer := Dialog.Confirm(Question, true, false);
                        if Answer = true then begin
                            ApprovalsMgmt.ApproveRecordApprovalRequest(Rec.RecordId);
                        end;
                    end;

                }
                action(Reject)
                {
                    ApplicationArea = All;
                    Caption = 'Reject';
                    Image = Reject;
                    ToolTip = 'Reject the approval request.';
                    Visible = OpenApprovalEntriesExistCurrUser;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        Question: Text;
                        Answer: Boolean;
                        Text000: Label 'Reject request?';
                    begin
                        Question := Text000;
                        Answer := Dialog.Confirm(Question, true, false);
                        if Answer = true then begin
                            ApprovalsMgmt.RejectRecordApprovalRequest(Rec.RecordId);
                        end;
                    end;

                }
                action(Delegate)
                {
                    ApplicationArea = All;
                    Caption = 'Delegate';
                    Image = Delegate;
                    ToolTip = 'Delegate the approval to a substitute approver.';
                    Visible = OpenApprovalEntriesExistCurrUser;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()

                    begin
                        ApprovalsMgmt.DelegateRecordApprovalRequest(Rec.RecordId);
                    end;
                }
                action(Comment)
                {
                    ApplicationArea = All;
                    Caption = 'Comments';
                    Image = ViewComments;
                    ToolTip = 'View or add comments for the record.';
                    Visible = OpenApprovalEntriesExistCurrUser;
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.GetApprovalComment(Rec);
                    end;
                }
                action(Approvals)
                {
                    ApplicationArea = All;
                    Caption = 'Approvals History';
                    Image = Approvals;
                    ToolTip = 'View approval requests.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    Visible = HasApprovalEntries;

                    trigger OnAction()
                    begin
                        ApprovalsMgmt.OpenApprovalEntriesPage(Rec.RecordId);
                    end;
                }

            }
            group("Request Approval")
            {
                Caption = 'Request Approval';
                Image = SendApprovalRequest;
                action(SendApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Send A&pproval Request';
                    Visible = NOT OpenApprovalEntriesExist AND (p::Open = Rec."Status") AND isCurrentUser;//! Could be use Enabled
                    Image = SendApprovalRequest;
                    ToolTip = 'Request approval to change the record.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Approval Wfl Mgt";
                        RecRef: RecordRef;
                    begin
                        // Rec.RequestDate := Today();
                        // RecRef.GetTable(Rec);
                        // if CustomWorkflowMgmt.CheckApprovalsWorkflowEnabled(RecRef) then begin
                        //     IF CanRequestApprovalForRecord then begin
                        //         CustomWorkflowMgmt.OnSendWorkflowForApproval(RecRef);
                        //         SetEditStatus();
                        //     end;
                        // end;
                    end;
                }
                action(CancelApprovalRequest)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Cancel Approval Re&quest';
                    Visible = CanCancelApprovalForRecord; //! Could be use Enabled
                    Image = CancelApprovalRequest;
                    ToolTip = 'Cancel the approval request.';
                    Promoted = true;
                    PromotedIsBig = true;
                    PromotedCategory = Process;
                    trigger OnAction()
                    var
                        CustomWorkflowMgmt: Codeunit "Approval Wfl Mgt";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        CustomWorkflowMgmt.OnCancelWorkflowForApproval(RecRef);
                        // SetEditStatus();
                    end;
                }

            }

            Action(Attachments)
            {
                ApplicationArea = All;
                Caption = 'Attach files';
                Image = Attachments;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = DynamicEditable;
                trigger OnAction()
                var
                    Helper: Codeunit Helper;
                    RecRef: RecordRef;
                begin
                    RecRef.GetTable(Rec);
                    Helper.AttachFile(RecRef);
                end;
            }
            action(UploadFile)
            {
                ApplicationArea = All;
                Caption = 'Upload Layout File', comment = '="YourLanguageCaption"';
                Image = Picture;
                Promoted = true;
                PromotedIsBig = true;
                PromotedCategory = Process;
                Enabled = DynamicEditable;
                trigger OnAction()
                begin
                    ImportFromDevice()
                end;
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    var
        ColorCylinderRec: Record "Cylinder-color";
        TypeEnum: Enum CylinderColorTypeEnum;
        CustomWflMgmt: Codeunit "Approval Wfl Mgt";
    begin
        if (Rec.No_ = '') then begin
            Rec.company_logo := true;
            CurrPage.Update(true);
            ColorCylinderRec.RequestId := Rec.No_;
            ColorCylinderRec.Type := TypeEnum::Color;
            ColorCylinderRec.Insert();
            ColorCylinderRec.RequestId := Rec.No_;
            ColorCylinderRec.Type := TypeEnum::Cylinder;
            ColorCylinderRec.Insert();
        end;
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        CanRequestApprovalForRecord := CustomWflMgmt.CanRequestApprovalForRecord(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        CanCancelApprovalForRecord := ApprovalsMgmt.CanCancelApprovalForRecord(Rec.RecordId);
        HasApprovalEntries := ApprovalsMgmt.HasApprovalEntries(Rec.RecordId);
        DynamicEditable := true;
    end;

    trigger OnInit()
    begin
        CurrPage."Attached Documents List".Page.setCylinderDocument();
        CurrPage.Update();
    end;

    var
        OpenApprovalEntriesExistCurrUser, OpenApprovalEntriesExist, CanCancelApprovalForRecord, CanRequestApprovalForRecord, HasApprovalEntries : Boolean;
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        DynamicEditable: Boolean;
        p: enum "Custom Approval Enum";
        isCurrentUser: Boolean;



    procedure ImportFromDevice()
    var
        FileManagement: Codeunit "File Management";
        FileName: Text;
        ClientFileName: Text;
        InStr: InStream;
    begin
        if Rec.LayoutFile.Count > 0 then
            if not Confirm(OverrideImageQst) then
                Error('');

        ClientFileName := '';
        UploadIntoStream(SelectPictureTxt, '', '', ClientFileName, InStr);
        if ClientFileName <> '' then
            FileName := FileManagement.GetFileName(ClientFileName);
        if FileName = '' then
            Error('');

        Clear(Rec.LayoutFile);
        Rec.LayoutFile.ImportStream(InStr, FileName);
        Rec.Modify(true);
    end;

    var
        OverrideImageQst: Label 'The existing picture will be replaced. Do you want to continue?';
        DeleteImageQst: Label 'Are you sure you want to delete the picture?';
        SelectPictureTxt: Label 'Select a picture to upload';
        DeleteExportEnabled: Boolean;
        HideActions: Boolean;
        MustSpecifyDescriptionErr: Label 'You must add a description to the item before you can import a picture.';
}