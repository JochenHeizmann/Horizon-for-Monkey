Import horizon.utilimage
Import horizon.guiwidgetimagebutton
Import horizon.guiwidget

Class GuiScrollbarVertical Extends GuiWidget
    Const VERTICAL_PADDING:Int = 2

    Global border:Image
    Global barTop:Image
    Global barMiddle:Image
    Global barBottom:Image
    Global barSign:Image

    Field maxValue:Float
    Field currValue:Float
    Field minValue:Float
    Field barValue:Float

    Field barY:Float

    Field startDrag:Int

    Field upBtn:GuiWidgetImagebutton
    Field downBtn:GuiWidgetImagebutton

    Method New()
        If (Not border Or Not barTop Or Not barMiddle Or Not barBottom) Then LoadImages()
        rect.w = ImageWidth(border)
        startDrag = -1
        barY = 0
        upBtn = GuiWidgetImagebutton.Create(GuiSystem.SKIN_PATH + "scrollbar/vertical/btn_up.png", rect.x, rect.y + rect.h)
        downBtn = GuiWidgetImagebutton.Create(GuiSystem.SKIN_PATH + "scrollbar/vertical/btn_down.png", rect.x, upBtn.rect.y + upBtn.rect.h)
        AddChild(upBtn)
        AddChild(downBtn)
    End Method

    Method UpdateScrollbarButtons()
        upBtn.rect.y = rect.y + rect.h
        upBtn.rect.x = rect.x
        downBtn.rect.y = upBtn.rect.y + upBtn.rect.h
        downBtn.rect.x = rect.x
        MoveBar(0)
    End Method

    Method SetWidgetHeight(y:Int)
        rect.h = y - upBtn.rect.h - downBtn.rect.h
    End Method

    Function LoadImages()
        border = LoadImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/border.png")
        border = LoadAnimImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/border.png", ImageWidth(border)/3, ImageHeight(border), 0, 3)

        barTop = LoadImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/bartop.png")
        barTop = LoadAnimImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/bartop.png", ImageWidth(barTop)/3, ImageHeight(barTop), 0, 3)

        barMiddle = LoadImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/barmiddle.png")
        barMiddle = LoadAnimImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/barmiddle.png", ImageWidth(barMiddle)/3, ImageHeight(barMiddle), 0, 3)

        barBottom = LoadImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/barbottom.png")
        barBottom = LoadAnimImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/barbottom.png", ImageWidth(barBottom)/3, ImageHeight(barBottom), 0, 3)

        barSign = LoadImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/barsign.png")
        barSign = LoadAnimImage(GuiSystem.SKIN_PATH + "scrollbar/vertical/barsign.png", ImageWidth(barSign)/3, ImageHeight(barSign), 0, 3)
    End Function

    Method Update()
        If (upBtn.IsClicked())
            MoveBar(-GetBarHeight() / 10)
        End If
        If (downBtn.IsClicked())
            MoveBar(GetBarHeight() / 10)
        End If
    End Method

    Method Render()
        DrawBorder()
        DrawBar()
    End Method

    Method DrawBar()
        Local frame:Int = 0

        If (widgetState = HOVER And IsMouseOverScrollbar()) Then frame = 1
        If (widgetState = DOWN And startDrag > -1) Then frame = 2

        Local y:Float = barY + rect.y + VERTICAL_PADDING
        Local x:Float = rect.x + ImageWidth(border) / 2 - ImageWidth(barTop) / 2
        Local h:Float = GetBarHeight()
        UtilImage.DrawRepeated(barMiddle, x, y + ImageHeight(barTop), ImageWidth(barMiddle), h - ImageHeight(barTop) - ImageHeight(barBottom) + 1, frame)
        DrawImage barTop, x, y, frame
        DrawImage barBottom, x, y + h - ImageHeight(barBottom), frame
        DrawImage barSign, x, y + h / 2 - ImageHeight(barSign) / 2, frame
    End Method

    Method DrawBorder()
        DrawImage border, rect.x, rect.y, 0
        UtilImage.DrawRepeated(border, rect.x, rect.y + ImageHeight(border), rect.w, rect.h - ImageHeight(border) * 2, 1)
        DrawImage border, rect.x, rect.y + rect.h - ImageHeight(border), 2
    End Method

    Method GetBarHeight:Float()
        Local sumHeight:Float = maxValue - minValue + 1
        Local h:Float = (rect.h - VERTICAL_PADDING * 2) / sumHeight
        Return Max(16.0, h)
    End Method

    Method OnMouseHit()
        Super.OnMouseHit()
        If (InputControllerMouse.GetInstance().GetY() > rect.y + VERTICAL_PADDING + barY And InputControllerMouse.GetInstance().GetY() < rect.y + VERTICAL_PADDING + barY + GetBarHeight())
            StartDragging()
        Else
            If (InputControllerMouse.GetInstance().GetY() < rect.y + VERTICAL_PADDING + barY)
                MoveBar(-GetBarHeight())
            Else
                MoveBar(GetBarHeight())
            End If
            If (IsMouseOverScrollbar()) Then StartDragging()
        End If
    End Method

    Method StartDragging()
        startDrag = InputControllerMouse.GetInstance().GetY() - (rect.y + VERTICAL_PADDING + barY)
    End Method

    Method IsMouseOverScrollbar:Bool()
        Return (InputControllerMouse.GetInstance().GetY() > rect.y + VERTICAL_PADDING + barY) And (InputControllerMouse.GetInstance().GetY() < rect.y + barY + VERTICAL_PADDING + GetBarHeight())
    End Method

    Method OnMouseMove(dx:Int, dy:Int)
        If startDrag > -1
            If (dy > 0) 'up
                If (InputControllerMouse.GetInstance().GetY() - rect.y - VERTICAL_PADDING > barY + startDrag) Then  Return
            Else If (dy < 0) 'down
                If (InputControllerMouse.GetInstance().GetY() - rect.y - VERTICAL_PADDING < barY + startDrag) Then Return
            End If
            MoveBar(-dy)
        End If
    End Method

    Method MoveBar(dy:Int)
        barY += dy
        barY = Min(Max(0.0, barY), rect.h - GetBarHeight() - VERTICAL_PADDING * 2)
    End Method

    Method OnMouseUp()
        Super.OnMouseUp()
        startDrag = -1
    End Method

    Method GetValue:Float()
        Local rangeValue:Float = maxValue - minValue
        Local maxBarValue:Float = (rect.h - VERTICAL_PADDING * 2) - GetBarHeight()
        Local v:Float
        If (maxBarValue > 0)
            Local factor:Float = rangeValue / maxBarValue
            v = barY * factor + minValue
            v = Min(maxValue, Max(minValue, v))
        Else
            v = 0
        End If
        Return v
    End Method
End
