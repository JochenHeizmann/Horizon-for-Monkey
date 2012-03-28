
Private

#if TARGET="ios"
Import "native/flurry.ios.cpp"

Extern  '<-- Externs 'Public' by default
Class Flurry
    Function Init:Void(apiKey$)="Flurry::Init"
    Function LogEvent:Void(eventName$)="Flurry::LogEvent"
    Function LogEventTimed:Void(eventName$)="Flurry::LogEventTimed"
    Function EndTimedEvent:Void(eventName$)="Flurry::EndTimedEvent"
End
#else
Public
Class Flurry
    Function Init:Void(apiKey$)
        Print "Flurry Init"
    End

    Function LogEvent:Void(eventName$)
        Print "Log: " + eventName
    End

    Function LogEventTimed:Void(eventName$)
        Print "Start Timed Event: " + eventName
    End

    Function EndTimedEvent:Void(eventName$)
        Print "End Timed Event: " + eventName
    End
End
#end
