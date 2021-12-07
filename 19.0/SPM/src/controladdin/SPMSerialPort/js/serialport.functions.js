Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('OnStartup')

async function OpenPort(SerialPortNo, BoudRate, DataBits, StopBits, Parity, BufferSize, FlowControl) {
    try {
        // Check if serial feature is available on the session
        // SSL is mandatory in google chrome
        if ('serial' in navigator)
        {
            stopRead = false;
            var ports = await navigator.serial.getPorts();
            var serialStopBits = 1;
            var serialParity = 'none';
            var serialFlow = 'none';

            if (ports.length == 0){
                port = await navigator.serial.requestPort();
            } else {
                port = ports[SerialPortNo];
            }
            
            switch(StopBits) {
                case 0:
                    serialStopBits = 1;
                    break;
                case 1:
                    serialStopBits = 2;
                    break;
            }
            
            switch(Parity) {
                case 0:
                    serialParity = 'none';
                    break;
                case 1:
                    serialParity = 'even';
                    break;
                case 2:
                    serialParity = 'odd';
                    break;
            }
            
            switch(FlowControl) {
                case 0:
                    serialFlow = 'none';
                    break;
                case 1:
                    serialFlow = 'hardware';
                    break;
            }
            
            await port.open({ 
                baudRate: BoudRate,
                dataBits: DataBits,
                stopBits: serialStopBits,
                parity: serialParity,
                bufferSize: BufferSize,
                flowControl: serialFlow
            });

            encoder = new TextEncoder();
            writer = port.writable.getWriter();   

            decoder = new TextDecoder();
            reader = port.readable.getReader();   

            listener = listenToPort();     

            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['01', '']);
        } else
        {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['10', '']);
        }
    }catch (exception) {
        console.error(exception);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['20', exception.message]);
    }
}

async function listenToPort() {
    isListening = true;

    while (true) {
        let value, done;
        try {
            ({ value, done } = await reader.read());
        } catch (exception) {
            console.error(exception);
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['30', exception.message]);

            break;
        }

        if (done) {
          break;
        }

        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('DataReceived', [decoder.decode(value)]);
    }

    reader.releaseLock();

    isListening = false;
}

async function SendMessage(dataToSend, addLineFeed) {
    try {
        if (addLineFeed)
            dataToSend += '\r\n';

        await writer.write(encoder.encode(dataToSend));
    }catch (exception) {
        console.error(exception);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['30', exception.message]);
    }
}

async function ClosePort() {
    try {
        if ('serial' in navigator)
        {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['05', '']);

            writer.releaseLock();
            // if listentoport has thrown an exception there is no need to trigger the cancel and wait the listener, is already gone and will trigger another error
            if (isListening){
                reader.cancel(); // close the listenToPort function (trigger done variable)
                await listener;
            }
            // close port is very slow, take something like 5 minutes to close the port, idk why.. close and reopen the page is much faster and release all the resources
            // and allow to reconnect without any problem
            await port.close();

            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['07', '']);
        } else
        {
            Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['10', '']);
        }
    }catch (exception) {
        console.error(exception);
        Microsoft.Dynamics.NAV.InvokeExtensibilityMethod('StatusHandler', ['20', exception.message]);
    }
}

function WriteFunnyLog(){
    if (!funnyLogWritten){
        console.log("%c💻 Application developed by %c Xwioch ", "color: white; font-size: 10px", "background: #993399; font-weight: bold; font-size: 10px; color: white; border-radius: 5px;");
        console.log("%c🌍 Project repo %chttps://github.com/Xwioch/BC.SerialPortManagement", "color: white; font-size: 10px", "color: #993399; font-weight: bold; font-size: 10px");
        funnyLogWritten = true; // startup trigger twice?
    }
}

var port;
var encoder, writer;
var decoder, reader;
var listener, isListening;
var funnyLogWritten;