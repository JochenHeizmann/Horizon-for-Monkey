
Import horizon.guiwidget
Import horizon.utilimage
Import fontmachine
Import horizon.blitzmaxfunctions

Class GuiWidgetButton Extends GuiWidget
    Const PADDING:Int = 10

    Field text : String
    Field font : BitmapFont = Null

    Function Create : GuiWidgetButton(text : String, x : Int, y : Int, w : Int, h : Int)
        Local b : GuiWidgetButton = New GuiWidgetButton
        b.text = text
        b.rect.x = x
        b.rect.y = y
        b.rect.h = h
        b.rect.w = w
        Return b
    End Function

    Method New()
        rect.w = 30
        rect.h = 20
    End Method

    Method SetText(t:String)
        text = t
    End Method

    Method AutoResize()
        rect.w = PADDING * 2 + font.TextWidth(text)
    End Method

    Method Update()
        Super.Update()
    End Method

    Method Render()
        Local frame:Int = 0
        Local off : Int = 0
        Select (GetWidgetState())
            Case HOVER
                frame = 3
            Case DOWN
                frame = 3
                off = 2
            Default
                frame = 0
        End Select

        SetColor ($59, $91, $bf)
        DrawRect(rect.x, rect.y, rect.w, rect.h)
        If GetWidgetState() = DOWN
            SetColor($09, $36, $69)
            DrawLine(rect.x, rect.y, rect.x + rect.w, rect.y)
            DrawLine(rect.x, rect.y, rect.x, rect.y + rect.h)
            SetColor($87, $bc, $f2)
            DrawLine(rect.x, rect.y + rect.h, rect.x + rect.w, rect.y + rect.h)
            DrawLine(rect.x + rect.w, rect.y, rect.x + rect.w, rect.y + rect.h)
        Else
            SetColor($87, $bc, $f2)
            DrawLine(rect.x, rect.y, rect.x + rect.w, rect.y)
            DrawLine(rect.x, rect.y, rect.x, rect.y + rect.h)
            SetColor($09, $36, $69)
            DrawLine(rect.x, rect.y + rect.h, rect.x + rect.w, rect.y + rect.h)
            DrawLine(rect.x + rect.w, rect.y, rect.x + rect.w, rect.y + rect.h)
        End If

        SetColor(0,0,0)
        SetAlpha(0.2)
        font.DrawText text, 2 + rect.x + (rect.w / 2) - font.GetTxtWidth(text) / 2, 2 + rect.y + (rect.h / 2) - font.GetFontHeight() / 2
        SetAlpha(1)
        SetColor(255, 255, 255)

        If (GetWidgetState() = HOVER) Then SetColor(255,255,255) Else SetColor(192,192,192)

        font.DrawText text, off + rect.x + (rect.w / 2) - font.GetTxtWidth(text) / 2, off + rect.y + (rect.h / 2) - font.GetFontHeight() / 2
        SetColor(255, 255, 255)
    End Method
End


