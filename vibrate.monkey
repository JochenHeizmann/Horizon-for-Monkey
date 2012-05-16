Private

#if TARGET="ios"
    Import "native/vibrate.${TARGET}.${LANG}"

    Public

    Extern
    Function Vibrate:Void()
    Public
#else
    Public
    Function Vibrate:Void()
    End
#end
