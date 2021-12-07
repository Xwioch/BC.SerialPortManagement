table 61000 "SPM Serial Port"
{
    Caption = 'Serial Port';
    LookupPageId = "SPM Serial Port Config.";
    DrillDownPageId = "SPM Serial Port Config.";
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(2; "Identifier No."; Integer)
        {
            Caption = 'Identifier No.';
            MinValue = 0;
            DataClassification = CustomerContent;
        }
        field(5; "Description"; Text[50])
        {
            Caption = 'Description';
            DataClassification = CustomerContent;
        }
        field(10; "Baud Rate"; Integer)
        {
            Caption = 'Baud Rate';
            InitValue = 9600;
            MinValue = 0;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(15; "Data Bits"; Integer)
        {
            Caption = 'Data Bits';
            InitValue = 8;
            MinValue = 0;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(20; "Stop Bits"; enum "SPM Stop Bits")
        {
            Caption = 'Stop Bits';
            DataClassification = CustomerContent;
        }
        field(25; "Parity"; Enum "SPM Parity Type")
        {
            Caption = 'Parity';
            DataClassification = CustomerContent;
        }
        field(30; "Buffer Size"; Integer)
        {
            Caption = 'Buffer Size';
            InitValue = 255;
            MinValue = 0;
            NotBlank = true;
            DataClassification = CustomerContent;
        }
        field(35; "Flow Control"; Enum "SPM Flow Control Type")
        {
            Caption = 'Flow Control';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}