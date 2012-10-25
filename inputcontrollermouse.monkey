Import mojo
Import horizon.application

Class InputControllerMouse
    Const NUM_BUTTONS:Int = 3

    Const BUTTON_LEFT:Int = 0
    Const BUTTON_RIGHT:Int = 1
    Const BUTTON_MIDDLE:Int = 2

    Const DBLCLICK_DELAY:Int = 250

    Global instance:InputControllerMouse

    Field buttonHit:Int[NUM_BUTTONS]
    Field buttonUp:Int[NUM_BUTTONS]
    Field buttonDown:Int[NUM_BUTTONS]
    Field mouseWheel:Int, oldMouseWheel:Int
    Field lastHit:Int[NUM_BUTTONS]

    Field mx:Float, my:Float
    Field oldMx:Float, oldMy:Float
    Field dx:Float, dy:Float

    Field time:Int

    Function GetInstance:InputControllerMouse()
        If Not InputControllerMouse.instance
            InputControllerMouse.instance = New InputControllerMouse
        End
        Return InputControllerMouse.instance
    End

    Method Refresh()
        RefreshLastHit()

        time = Millisecs()
        RefreshMouseCoords()
        RefreshMouseHit()
        RefreshMouseUp()
    End

    Method RefreshMouseCoords()
        oldMx = mx
        oldMy = my
        mx = Application.GetInstance().VirtualMouseX()
        my = Application.GetInstance().VirtualMouseY()
        dx = oldMx - mx
        dy = oldMy - my
        If (dx <> 0 Or dy <> 0)
            For Local i:Int = 0 To NUM_BUTTONS-1
                lastHit[i] = 0
            Next
        End
    End

    Method GetX:Float()
        Return Application.GetInstance().VirtualMouseX()
    End

    Method GetY:Float()
        Return Application.GetInstance().VirtualMouseY()
    End

    Method GetDX:Float()
        Return dx
    End

    Method GetDY:Float()
        Return dy
    End

    Method RefreshMouseUp()
        For Local i:Int = 0 To NUM_BUTTONS-1
            Local bd:Bool = TouchDown(i) > 0
            If (buttonDown[i] And Not bd) Then buttonUp[i] = True Else buttonUp[i] = False
            buttonDown[i] = bd
        Next
    End

    Method RefreshMouseHit()
        For Local i:Int = 0 To NUM_BUTTONS-1
            buttonHit[i] = MouseHit(i)
        Next
    End

    Method RefreshLastHit()
        For Local i:Int = 0 To NUM_BUTTONS-1
            If buttonHit[i] Then lastHit[i] = time
        Next
    End

    Method IsMouseDown:Int(btn:Int)
''        Return TouchDown(btn)
        Return buttonDown[btn]
    End

    Method IsMouseHit:Int(btn:Int)
 ''       Return TouchHit(btn)
        Return buttonHit[btn]
    End

    Method IsDoubleMouseHit:Int(btn:Int)
        Return (IsMouseHit(btn) And time > lastHit[btn] And lastHit[btn] + DBLCLICK_DELAY > Millisecs())
    End

    Method IsMouseUp:Int(btn:Int)
        Return buttonUp[btn]
    End

    Method GetMouseWheel:Int()
        Return mouseWheel
    End
End
