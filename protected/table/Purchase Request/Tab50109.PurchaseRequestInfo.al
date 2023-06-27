table 50109 "Purchase Request Info"
{
    Caption = 'Purchase Request Info';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; No_; Code[10])
        {
            Caption = 'No.';
            Editable = false;
            DataClassification = ToBeClassified;
            trigger OnValidate()
            begin
                if "No_" <> xRec."No_" then begin
                    NoSeriesSetup.Get();
                    NoSeriesMgt.TestManual(NoSeriesSetup."Price Approval No.");
                    "No. Series" := '';
                end;
            end;
        }
        field(2; request_approval_id; Integer)
        {
            Caption = 'request_approval_id';
            DataClassification = ToBeClassified;
        }
        field(3; pr_number; Text[32])
        {
            Caption = 'pr_number';
            DataClassification = ToBeClassified;
        }
        field(4; pr_type; Integer)
        {
            Caption = 'pr_type';
            DataClassification = ToBeClassified;
        }
        field(5; pr_phone; Text[32])
        {
            Caption = 'pr_phone';
            DataClassification = ToBeClassified;
        }
        field(6; pr_notes; Text[500])
        {
            Caption = 'pr_notes';
            DataClassification = ToBeClassified;
        }
        field(7; estimated_delivery_by; Integer)
        {
            Caption = 'estimated_delivery_by';
            DataClassification = ToBeClassified;
        }
        field(8; estimated_delivery_date; Date)
        {
            Caption = 'estimated_delivery_date';
            DataClassification = ToBeClassified;
        }
        field(9; department_end_user; Integer)
        {
            Caption = 'department_end_user';
            DataClassification = ToBeClassified;
        }
        field(10; ps_no; Text[32])
        {
            Caption = 'ps_no';
            DataClassification = ToBeClassified;
        }
        field(11; "Request By"; Text[200])
        {
            Caption = 'NguoiYeuCau';
            DataClassification = ToBeClassified;
        }
        field(12; TenBoPhan; Text[200])
        {
            Caption = 'TenBoPhan';
            DataClassification = ToBeClassified;
        }
        field(13; NgayPsNhap; Text[200])
        {
            Caption = 'NgayPsNhap';
            DataClassification = ToBeClassified;
        }
        field(14; DienGiaiChung; Text[500])
        {
            Caption = 'DienGiaiChung';
            DataClassification = ToBeClassified;
        }
        field(15; NgayGetPs; Date)
        {
            Caption = 'NgayGetPs';
            DataClassification = ToBeClassified;
        }
        field(16; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
        }
        field(17; Status; Enum "Custom Approval Enum")
        {
            DataClassification = ToBeClassified;
        }
        field(18; RequestDate; Date)
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {
        key(PK; No_)
        {
            Clustered = true;
        }
    }
    trigger OnInsert()
    begin
        if "No_" = '' then begin
            NoSeriesSetup.Get();
            NoSeriesSetup.TestField("Purchase Request No.");
            NoSeriesMgt.InitSeries(NoSeriesSetup."Purchase Request No.", xRec."No. Series", 0D, "No_", "No. Series");
        end;

    end;

    var
        NoSeriesSetup: Record "No. Series Setup";
        NoSeriesMgt: Codeunit NoSeriesManagement;
}
