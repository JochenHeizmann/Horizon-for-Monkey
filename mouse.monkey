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
#Else
    Public
    Class Mouse
        Function Show:Void()
        End
        Function Hide:Void()
        End
    End
#End