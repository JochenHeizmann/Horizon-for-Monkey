Private

#if TARGET="flash"
    Import "native/mouse.${TARGET}.${LANG}"

    Public

    Extern
    	Class Mouse="mouse"
    		Function Show:Void()="mouse.Show"
    		Function Hide:Void()="mouse.Hide"
    	End
    Public
#else
    Class Mouse
        Function Show:Void()
            ShowMouse()
        End
        Function Hide:Void()
            HideMouse()
        End
    End
End