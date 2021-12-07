page 61000 "SPM Serial Port Connection"
{
    Caption = 'Serial Port Connection (SPM)';
    PageType = Card;
    UsageCategory = Tasks;
    ApplicationArea = All;
    SourceTable = "SPM Serial Port";
    SourceTableTemporary = true;
    InsertAllowed = false;
    DeleteAllowed = false;

    layout
    {
        area(Content)
        {
            usercontrol("SPM Serial Port"; "SPM Serial Port")
            {
                ApplicationArea = All;

                trigger OnStartup()
                begin
                    IsAddinReady := true;

                    CurrPage."SPM Serial Port".WriteFunnyLog();
                end;

                trigger StatusHandler(StatusCode: Code[10]; Exception: Text)
                var
                    SerialConnClosedMsg: Label 'Serial connection closed';
                    SerialConnEstablishedMsg: Label 'Serial connection established';
                    SerialFeatureNotAvailErr: Label 'Serial feature not available for the web browser. Check all the features on the settings or check if SSL is enabled';
                    SerialOpenFailedErr: Label 'There was an error while trying to open or close the serial port';
                    SerialPortClosingMsg: Label 'Connection is closing, this could take a while...';
                    SerialSendFailedErr: Label 'There was a problem sending the message to the serial port. Check the communication';
                begin
                    SerialException := Exception;

                    case StatusCode of
                        '01':
                            begin
                                StatusMessage := SerialConnEstablishedMsg;
                                ConnectionStatus := ConnectionStatus::Connected;
                                ConnectionStatusStyle := 'Favorable';
                            end;
                        '05':
                            begin
                                StatusMessage := SerialPortClosingMsg;
                                ConnectionStatus := ConnectionStatus::"In Progress";
                                ConnectionStatusStyle := 'StrongAccent';
                            end;
                        '07':
                            begin
                                StatusMessage := SerialConnClosedMsg;
                                ConnectionStatus := ConnectionStatus::" ";
                                ConnectionStatusStyle := '';
                            end;
                        '10':
                            begin
                                StatusMessage := SerialFeatureNotAvailErr;
                                ConnectionStatus := ConnectionStatus::Failed;
                                ConnectionStatusStyle := 'Unfavorable';
                            end;
                        '20':
                            begin
                                StatusMessage := SerialOpenFailedErr;
                                ConnectionStatus := ConnectionStatus::Failed;
                                ConnectionStatusStyle := 'Unfavorable';
                            end;
                        '30':
                            begin
                                StatusMessage := SerialSendFailedErr;
                                ConnectionStatus := ConnectionStatus::Failed;
                                ConnectionStatusStyle := 'Unfavorable';
                            end;
                    end;
                end;

                trigger DataReceived(Data: Text)
                begin
                    CurrPage."SPM Serial Port Conn. Subform".Page.AddMessage(0, Data);

                    CurrPage.Update(false); // only for subform sorting, this could cause UI problems
                end;
            }

            group("Configuration")
            {
                Caption = 'Configuration';

                field(SerialPortCode; SerialPortCode)
                {
                    Caption = 'Code';
                    ToolTip = 'Specifies the code for the serial port configuration';
                    Importance = Promoted;
                    ApplicationArea = All;

                    trigger OnValidate()
                    var
                        SPMSerialPort: Record "SPM Serial Port";
                    begin
                        SPMSerialPort.Get(SerialPortCode);
                        SetConfiguration(SPMSerialPort);
                    end;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        SPMSerialPort: Record "SPM Serial Port";
                        SPMSerialPortConfig: Page "SPM Serial Port Config.";
                    begin
                        Clear(SPMSerialPortConfig);
                        SPMSerialPortConfig.LookupMode := true;

                        if SPMSerialPort.Get(SerialPortCode) then
                            SPMSerialPortConfig.SetRecord(SPMSerialPort);

                        if SPMSerialPortConfig.RunModal() in [Action::OK, Action::LookupOK] then begin
                            SPMSerialPortConfig.GetRecord(SPMSerialPort);
                            "Text" := SPMSerialPort."Code";

                            exit(true);
                        end;

                        exit(false);
                    end;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies the configuration description of the serial port';
                    Editable = false;
                    ApplicationArea = All;
                }

                group("Options")
                {
                    Caption = 'Options';

                    field("Identifier No."; Rec."Identifier No.")
                    {
                        ToolTip = 'Specifies the number the idenfity the port on the list of the request devices. Is not che port name (ex. COM1), is the number on the decives array proposed by the requestPort';
                        Importance = Promoted;
                        ShowMandatory = true;
                        ApplicationArea = All;
                    }
                    field("Baud Rate"; Rec."Baud Rate")
                    {
                        ToolTip = 'Specifies the boud rate for the serial port';
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field("Data Bits"; Rec."Data Bits")
                    {
                        ToolTip = 'Specifies the data bits for the serial port';
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field("Stop Bits"; Rec."Stop Bits")
                    {
                        ToolTip = 'Specifies the stop bits for the serial port';
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field(Parity; Rec.Parity)
                    {
                        ToolTip = 'Specifies the parity type for the serial port';
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                    field("Buffer Size"; Rec."Buffer Size")
                    {
                        ToolTip = 'Specifies the buffer size for the serial port';
                        Importance = Additional;
                        Visible = false;
                        ApplicationArea = All;
                    }
                    field("Flow Control"; Rec."Flow Control")
                    {
                        ToolTip = 'Specifies the flow control type for the serial port';
                        Importance = Additional;
                        ApplicationArea = All;
                    }
                }

                group("Status")
                {
                    ShowCaption = false;

                    field(ConnectionStatus; ConnectionStatus)
                    {
                        Caption = 'Status';
                        ToolTip = 'Specifies the connection status for the selected serial port';
                        OptionCaption = ' ,Connected,Failed,In Progress';
                        Editable = false;
                        StyleExpr = ConnectionStatusStyle;
                        ApplicationArea = All;
                    }
                    field(StatusMessage; StatusMessage)
                    {
                        Caption = 'Status Message';
                        ToolTip = 'Specifies the connection status message for the selected serial port';
                        Editable = false;
                        ApplicationArea = All;
                    }
                    field(SerialException; SerialException)
                    {
                        Caption = 'Exception';
                        ToolTip = 'Specifies the exception from the javascript add-in';
                        Editable = false;
                        Importance = Additional;
                        MultiLine = true;
                        ApplicationArea = All;
                    }
                }

                group("Outbound")
                {
                    ShowCaption = false;

                    field(OutboundMessage; OutboundMessage)
                    {
                        Caption = 'Send';
                        ToolTip = 'Specifies the message to send on the serial port';
                        MultiLine = true;
                        ApplicationArea = All;

                        trigger OnAssistEdit()
                        begin
                            CurrPage."SPM Serial Port".SendMessage(OutboundMessage, AddLineFeed);
                            CurrPage."SPM Serial Port Conn. Subform".Page.AddMessage(1, OutboundMessage);
                            OutboundMessage := '';

                            CurrPage.Update(false);
                        end;
                    }
                    field(AddLineFeed; AddLineFeed)
                    {
                        Caption = 'Send with line feed';
                        ToolTip = 'Specifies if the message must be sent with \r\n characters';
                        ApplicationArea = All;
                    }
                }
            }
            part("SPM Serial Port Conn. Subform"; "SPM Serial Port Conn. Subform")
            {
                Caption = 'Terminal';
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action("Open Port")
            {
                Caption = 'Open Port';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Open;
                ToolTip = 'Open the connection with the selected serial port';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if IsAddinReady then
                        CurrPage."SPM Serial Port".OpenPort(Rec."Identifier No.", Rec."Baud Rate", Rec."Data Bits", Rec."Stop Bits", Rec.Parity, Rec."Buffer Size", Rec."Flow Control");
                end;
            }
            action("Close Port")
            {
                Caption = 'Close Port';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = Close;
                ToolTip = 'Close the connection with the selected serial port';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    if IsAddinReady then
                        CurrPage."SPM Serial Port".ClosePort();
                end;
            }
            action("Clear Terminal")
            {
                Caption = 'Clear Terminal';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Image = ClearLog;
                ToolTip = 'Delete all the lines on the terminal subform';
                ApplicationArea = All;

                trigger OnAction()
                begin
                    CurrPage."SPM Serial Port Conn. Subform".Page.ClearTerminal();
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        AddLineFeed := true;
    end;

    procedure SetConfiguration(SPMSerialPort: Record "SPM Serial Port")
    begin
        Rec.Reset();
        Rec.DeleteAll();

        Rec := SPMSerialPort;
        if Rec.Insert() then;
    end;

    var
        AddLineFeed: Boolean;
        IsAddinReady: Boolean;
        SerialPortCode: Code[10];
        ConnectionStatus: Option " ","Connected","Failed","In Progress";
        ConnectionStatusStyle: Text;
        OutboundMessage: Text;
        SerialException: Text;
        StatusMessage: Text;
}