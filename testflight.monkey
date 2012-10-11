Private

#if TARGET="ios"
    Import "native/testflight.ios.cpp"

    Extern
    Class Testflight="TestflightMonk"
        Function SetDeviceIdentifier:Void()="TestflightMonk::SetDeviceIdentifier"
        Function TakeOff:Void(teamToken$)="TestflightMonk::TakeOff"
        Function PassCheckpoint:Void(checkpointName$)="TestflightMonk::PassCheckpoint"
    End
#else
    Public
    Class Testflight
        Function SetDeviceIdentifier:Void()
        End

        Function TakeOff:Void(teamToken$)
        End

        Function PassCheckpoint:Void(checkpointName$)
        End        
    End
#end