Private

#if TARGET="ios"
Import "native/appirater.ios.cpp"

Extern
Class Appirater="AppiraterMonk"
    Function Launched:Void()="AppiraterMonk::Launched"
End
#else
Public
Class Appirater
    Function Launched:Void()
    End
End
#end
