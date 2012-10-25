Import mojo

Class FPSCounter
    Field fpsTimer#
    Field fpsFrame%
    Field fps%

    Method New()
        NextTick()
    End

    '
    ' Call this Method on each frame
    '
    Method OnEnterFrame:Void()
        If (Millisecs() < fpsTimer)
            fpsFrame += 1
        Else
            NextTick()
        End
    End

    Method NextTick:Void()
        fps = fpsFrame
        fpsFrame = 1
        fpsTimer = Millisecs() + 1000
    End

    '
    ' Call this method to detect the last number of frames
    '
    Method GetFPS%()
        Return fps
    End
End