# Serial Port Management

Handle serial port through web browser in business central using Web Serial API

## Explanation

Since Business Central is a web based application and doesn't have a client anymore handle devices like serial port become more difficult. The purpose of this app is show an easy way on how to manage serial port using Web Serial API feature of some browsers (like Chrome).
The only way to access the feature is through javascript so the app use a control add-in that doesn't create a real UI, is just an invisible control but, that in background, runs a listener that keep receiving data from a serial port. 
When the listener receive a string an event is triggered and send the data to the business central page and there it's easy to manipulate data.
The control add-in can be added in every page that need to receive or send data to a serial port. 
It's cool because there's no need to create web services call or doing stuffs server based for handle the data transfer, is enough a web browser with the Web Serial API feature, so even a SaaS configuration can work with this development. 

## Quick Sample

The Serial Port Connection (SPM) page allow to test che connection, so if were already made a connection with a serial port is enough insert the Identifier No. and it will connect without prompt any request but, if is the first time there's no way to avoid an initial request of the port to deal with. 

Placeholder image 1

Once the serial parameters are configured simply click open to establish the connection.
All sent and received data are shown on the Terminal subpage under che configuration.

Placeholder image 2

If any error or exceptions are triggered during the connection the status will become Failed and the message will show what happaned.

If you want to avoid to create another add-in and use this one instead here a sample of the code to declare on your page with all the triggers for handle data.

```al
usercontrol("SPM Serial Port"; "SPM Serial Port")
{
    ApplicationArea = All;

    trigger OnStartup()
    begin
    end;
    
    trigger StatusHandler(StatusCode: Code[10]; Exception: Text)
    begin
    end;
    
    trigger DataReceived(Data: Text)
    begin
    end;
}
```

## About Web Serial API

As explained above Web Serial API is a feature of some browser, since is pretty new is now stable but hasn't much considerations and there aren't a lot of samples on the web. 
If you want to know more about it this are the main articles that provide some good code explaination that I used on my app:

* [Serial API (github repo)](https://github.com/WICG/serial)
* [Web Serial API (docs)](https://wicg.github.io/serial/)

Web Serial API only works with secure connections, so with HTTPS/SSL websites with trusted certificates.
You can check if the feature is enabled on your browser using a permission test web site (ex. [permission.site](https://permission.site/))

## Test environment with Docker

For test the functionality you can create a Docker container and manage virtual serial ports on your device.
According with what I said before we need a secure connection so add the -useSSL parameter on your powershell script:

```powershell
New-BcContainer -accept_eula `
                -accept_outdated `
                -artifactUrl $artifactUrl `
                -auth UserPassword `
                -containerName $containername `
                -Credential $bccredential `
                -licenseFile $licenseFile `
                -enableTaskScheduler `
                -dns '8.8.8.8' `
                -updateHosts `
                -useSSL `
                -useBestContainerOS `
                -additionalParameters $additionalParameters
```

Create the container and then a certificate.cer will be available to download.
It should be on a link like this one: http://{containername}:8080/certificate.cer
Add this certificate on your root folder on the certificate snap-in in mmc (if you don't know what I'm talking about search on the web how to add a certificate on your local computer). 
For create a virtual serial port bridge I used this software [Virtual Serial Port](https://www.hhdsoftware.com/virtual-serial-ports).
Is available free with low features but are enough for a simple implementathion.

## Known issues

One of the main problem that I saw during the development is that the serial port close function works really bad.
it tooks something like 5 minute to release all the stream (writer/reader) and I don't know why just because if you close and repoen the page it will reinitialize che control and you can connect again without any problem.
If you use the port.close() procedure it will wait for a long time until is ready for a new connection.

```javascript
writer.releaseLock();
// if listentoport has thrown an exception there is no need to trigger the cancel and wait the listener, is already gone and will trigger another error
    if (isListening){
        reader.cancel(); // close the listenToPort function (trigger done variable)
        await listener;
    }
// close port is very slow, take something like 5 minutes to close the port, idk why.. close and reopen the page is much faster and release all the resources
    // and allow to reconnect without any problem
    await port.close();
```

Close the serial connection is always a delicate operation, you need to flush streams, dispose object and so on, but with Web Serial API seems working really bad so a good approach according to me is close and reopen the UI so it deletes che control and it will recreate a brand new one ready for connections. 


