table 50114 "cylinder info"
{
    Caption = 'cylinder info';
    DataClassification = ToBeClassified;

    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
        }
        // field(2; supplier; )
        // {
        //     Caption = 'supplier';
        // }
        field(3; QCSP; Text[200])
        {
            Caption = 'QCSP';
        }
        field(4; product_name; Text[500])
        {
            Caption = 'product_name';
        }
        // field(5; cylinder_status; )
        // {
        //     Caption = 'cylinder_status';
        // }
        field(6; quantity; text[10])
        {
            Caption = 'quantity';
        }
        // field(7; cylinder_type; )
        // {
        //     Caption = 'cylinder_type';
        // }
        field(8; cylinder_type_other; Text[100])
        {
            Caption = 'cylinder_type_other';
        }
        field(9; size_perimeter; Text[100])
        {
            Caption = 'size_perimeter';
        }
        field(10; size_length; Text[100])
        {
            Caption = 'size_length';
        }
        field(11; size_note; Text[100])
        {
            Caption = 'size_note';
        }
        field(12; print_material; Text[250])
        {
            Caption = 'print_material';
        }
        field(13; film_size; Text[250])
        {
            Caption = 'film_size';
        }
        // field(14; print_area; )
        // {
        //     Caption = 'print_area';
        // }
        field(15; effective_proof; Boolean)
        {
            Caption = 'effective_proof';

        }
        field(16; effective_file; Boolean)
        {
            Caption = 'effective_file';
        }
        field(17; effective_sample_bag; Boolean)
        {
            Caption = 'effective_sample_bag';
        }
        field(18; effective_other; Boolean)
        {
            Caption = 'effective_other';
        }
        field(19; effective_other_value; text[100])
        {
            Caption = 'effective_other_value';
        }
        field(20; company_logo; Boolean)
        {
            Caption = 'company_logo';
        }

        field(41; product_width; text[50])
        {
            Caption = 'product_width';
        }
        field(42; product_height; text[50])
        {
            Caption = 'product_height';
        }
        field(43; page_number_width; text[50])
        {
            Caption = 'page_number_width';
        }
        field(44; page_number_height; text[50])
        {
            Caption = 'page_number_height';
        }
        // field(45; file_info_cromalin; )
        // {
        //     Caption = 'file_info_cromalin';
        // }
        // field(46; file_info_proof; )
        // {
        //     Caption = 'file_info_proof';
        // }
        // field(47; file_info_layout; )
        // {
        //     Caption = 'file_info_layout';
        // }
        // field(48; file_info_color; )
        // {
        //     Caption = 'file_info_color';
        // }
        field(49; page_layout; text[250])
        {
            Caption = 'page_layout';
        }
        field(50; other_note; text[2048])
        {
            Caption = 'other_note';
        }
        field(51; ink_type; text[50])
        {
            Caption = 'ink_type';
        }
    }
    keys
    {
        key(PK; "No.")
        {
            Clustered = true;
        }
    }
}
