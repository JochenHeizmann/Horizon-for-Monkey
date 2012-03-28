
Private

#if TARGET="ios"
Import "native/appirater.ios.cpp"

Extern  '<-- Externs 'Public' by default
Class Appirater
    Function Launched:Void()="Appirater::Launched"
End
#else
Public
Class Appirater
    Function Launched:Void()
        Print "Appirater: App launched"
    End
End
#end
