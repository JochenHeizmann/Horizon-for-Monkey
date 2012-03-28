
Private

#if TARGET="ios"
Import "native/appirater.ios.cpp"

Extern  '<-- Externs 'Public' by default
Class Appirater
    Function Launched:Void()="Appirater::Launched"
End
#else
Class Appirater
    Function Launched:Void()="Appirater::Launched"
        Print "Appirater: App launched"
    End
End
#end
