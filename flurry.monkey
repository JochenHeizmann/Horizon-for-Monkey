
Private

#if TARGET="ios" Or TARGET="android"
Import "native/flurry.${TARGET}.${LANG}"

Extern
#if TARGET="ios"
    Class Flurry
        Function Init:Void(apiKey$)="Flurry::Init"
        Function LogEvent:Void(eventName$)="Flurry::LogEvent"
        Function LogEventTimed:Void(eventName$)="Flurry::LogEventTimed"
        Function EndTimedEvent:Void(eventName$)="Flurry::EndTimedEvent"
    End
#elseif TARGET="android"
Class Flurry
        Function Init:Void(apiKey$)="Flurry.Init"
        Function LogEvent:Void(eventName$)="Flurry.LogEvent"
        Function LogEventTimed:Void(eventName$)="Flurry.LogEventTimed"
        Function EndTimedEvent:Void(eventName$)="Flurry.EndTimedEvent"
    End
#end

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
