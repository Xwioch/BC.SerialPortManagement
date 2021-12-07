table 61001 "SPM Serial Port Buffer"
{
    Caption = 'Serial Port Buffer';
    DataClassification = CustomerContent;

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = CustomerContent;
        }
        field(5; "Direction"; Option)
        {
            Caption = 'Direction';
            OptionMembers = "Inbound","Outbound";
            OptionCaption = 'Inbound,Outbound';
            DataClassification = CustomerContent;
        }
        field(10; "Message"; Text[250])
        {
            Caption = 'Message';
            DataClassification = CustomerContent;
        }
        field(20; "Date-Time"; DateTime)
        {
            Caption = 'Date-Time';
            DataClassification = CustomerContent;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
    }
}