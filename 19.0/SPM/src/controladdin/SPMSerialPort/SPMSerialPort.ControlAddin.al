controladdin "SPM Serial Port"
{
    // Invisible addin
    RequestedHeight = 0;
    MinimumHeight = 0;
    RequestedWidth = 0;
    MaximumWidth = 0;

    StartupScript = 'src/controladdin/SPMSerialPort/js/serialport.functions.js';

    Scripts = 'src/controladdin/SPMSerialPort/js/serialport.functions.js';

    event OnStartup()
    event StatusHandler(StatusCode: Code[10]; Exception: Text)
    event DataReceived(Data: Text)

    procedure OpenPort(IdentifierNo: Integer; BoudRate: Integer; DataBits: Integer; StopBits: Enum "SPM Stop Bits"; Parity: Enum "SPM Parity Type"; BufferSize: Integer; FlowControl: Enum "SPM Flow Control Type")
    procedure ClosePort()
    procedure SendMessage(Data: Text; WithLineFeed: Boolean)
    procedure WriteFunnyLog()
}