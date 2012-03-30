
import com.flurry.android.FlurryAgent;

class Flurry
{
    static void Init(String apiKey)
    {
        FlurryAgent.onStartSession(MonkeyGame.activity, apiKey);
    }

    static void Stop()
    {
        FlurryAgent.onEndSession(MonkeyGame.activity);
    }

    static void LogEvent(String eventName)
    {
        FlurryAgent.logEvent(eventName);
    }

    static void LogEventTimed(String eventName)
    {
        FlurryAgent.logEvent(eventName, true);
    }

    static void EndTimedEvent(String eventName)
    {
        FlurryAgent.endTimedEvent(eventName);
    }
}
