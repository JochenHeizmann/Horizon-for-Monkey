
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
    End

    Function LogEvent:Void(eventName$)
    End

    Function LogEventTimed:Void(eventName$)
    End

    Function EndTimedEvent:Void(eventName$)
    End
End
#end
