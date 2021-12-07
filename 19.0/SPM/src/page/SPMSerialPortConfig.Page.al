page 61002 "SPM Serial Port Config."
{
    Caption = 'Serial Port Configuration (SPM)';
    PageType = List;
    UsageCategory = Administration;
    SourceTable = "SPM Serial Port";
    ApplicationArea = All;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the configuration code of the serial port';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the configuration description of the serial port';
                    ApplicationArea = All;
                }
                field("Identifier No."; Rec."Identifier No.")
                {
                    ToolTip = 'Specifies the number the idenfity the port on the list of the request devices. Is not che port name (ex. COM1), is the number on the decives array proposed by the requestPort';
                    ApplicationArea = All;
                }
                field("Baud Rate"; Rec."Baud Rate")
                {
                    ToolTip = 'Specifies the boud rate for the serial port';
                    ApplicationArea = All;
                }
                field("Data Bits"; Rec."Data Bits")
                {
                    ToolTip = 'Specifies the data bits for the serial port';
                    ApplicationArea = All;
                }
                field("Stop Bits"; Rec."Stop Bits")
                {
                    ToolTip = 'Specifies the stop bits for the serial port';
                    ApplicationArea = All;
                }
                field(Parity; Rec.Parity)
                {
                    ToolTip = 'Specifies the parity type for the serial port';
                    ApplicationArea = All;
                }
                field("Buffer Size"; Rec."Buffer Size")
                {
                    ToolTip = 'Specifies the buffer size for the serial port';
                    Visible = false;
                    ApplicationArea = All;
                }
                field("Flow Control"; Rec."Flow Control")
                {
                    ToolTip = 'Specifies the flow control type for the serial port';
                    ApplicationArea = All;
                }
            }
        }
    }
}