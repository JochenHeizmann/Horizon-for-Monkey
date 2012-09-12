
#if TARGET="android"
    Import "multimusic/multimusic.android.java"

Public

Extern
    Class MultiMusic="MultiMusic"
        Method LoadMusic%(path$, channel%)
        Method StopMusic%(channel%)
        Method PlayMusic%(channel%, flags%)
        Method UnmuteMusic%(channel%)
        Method MuteMusic%(channel%)
        Method MusicChannelState%(channel%)
        Method ClearAll:Void()
        Method FreeChannel%(channel%)
    End
#end

