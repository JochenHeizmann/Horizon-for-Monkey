
#import "FlurryAnalytics.h"

class Flurry
{
public:
    static void uncaughtExceptionHandler(NSException *exception)
    {
        [FlurryAnalytics logError:@"Uncaught Exception" message:@"Crash!" exception:exception];
    }

    void static Init(String apiKey)
    {
        printf("%s\n", __func__);
        NSSetUncaughtExceptionHandler(&Flurry::uncaughtExceptionHandler);
        [FlurryAnalytics startSession:apiKey.ToNSString()];
        [FlurryAnalytics setSessionReportsOnCloseEnabled:YES];
        [FlurryAnalytics setSessionReportsOnPauseEnabled:YES];
    }

    void static LogEvent(String eventName)
    {
        printf( "%s: %s\n", __func__, eventName.ToCString<char>() );
        [FlurryAnalytics logEvent:eventName.ToNSString()];
    }

    void static LogEventTimed(String eventName)
    {
        printf( "%s: %s\n", __func__, eventName.ToCString<char>() );
        [FlurryAnalytics logEvent:eventName.ToNSString() timed:YES];
    }

    void static EndTimedEvent(String eventName)
    {
        printf( "%s: %s\n", __func__, eventName.ToCString<char>() );
        [FlurryAnalytics endTimedEvent:eventName.ToNSString() withParameters:nil];
    }
};











