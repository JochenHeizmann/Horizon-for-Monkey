Import horizon.inputcontrollermouse
Import horizon.guibase
Import mojo
'Import horizon.blitzmaxfunctions
'
Class GuiSystem
    Global topElement : GuiBase
    Global selectedElement : GuiBase
    Global activeElement : GuiBase
    Global modalElement : GuiBase

    Global widgets : List<GuiBase>
    Global mouse : InputControllerMouse

    Global SKIN_PATH:String = "gfx/gui/"

    Function Init()
        widgets = New List<GuiBase>
        mouse = InputControllerMouse.GetInstance()
    End Function

    Function RenderAll(darkenBG:Bool = True)
        For Local w : GuiBase = EachIn widgets
            If w.visible And w.autoRender
                If (darkenBG And w = modalElement)
                    SetAlpha(0.7)
                    SetColor(0,0,0)
                    DrawRect 0,0,Application.GetInstance().width, Application.GetInstance().height
                    SetColor(255,255,255)
                    SetAlpha(1)
                    w.Render()
                Else
                    w.Render()
                End
            End
        Next
    End Function

    Function ClearWidgets()
        topElement = Null
        selectedElement = Null
        activeElement = Null
        modalElement = Null
        widgets.Clear()
    End Function

    Function HideAllWidgets()
        For Local w:GuiBase = EachIn widgets
            w.Hide()
        Next
    End Function

    Function RemoveWidget(w:GuiBase)
        For Local w:GuiBase = EachIn w.childs
            RemoveWidget(w)
        Next
        widgets.Remove(w)
    End Function

    Function GetModalElement:GuiBase()
        Local m:GuiBase
        For Local w : GuiBase = EachIn widgets
            If w.visible And w.isModal
                m = w
            End
        Next
        Return m
    End Function

    Function ProcessMessages()
        Local oldTopElement : GuiBase = topElement
        modalElement = GetModalElement()

        topElement = Null
        For Local w : GuiBase = EachIn widgets
            If w.visible And w.IsChildOf(modalElement)                    
                If (w.rect.IsInRect(mouse.GetX(), mouse.GetY()))
                    topElement = w
                End
            End
        Next

        For Local w : GuiBase = EachIn widgets
            If w.visible
                w.Update()
            End
        Next

        ' send onMouseOver / onMouseOut
        If (topElement <> oldTopElement)
            If (topElement) Then topElement.OnMouseOver()
            If (oldTopElement) Then oldTopElement.OnMouseOut()
        End

        If (mouse.IsMouseHit(mouse.BUTTON_LEFT))
            activeElement = Null
        End

        If (topElement)
            If (mouse.IsMouseHit(mouse.BUTTON_LEFT))
                topElement.OnMouseHit()
                selectedElement = topElement
                activeElement = topElement
                activeElement.OnActivate()
            End

            If (mouse.IsMouseDown(mouse.BUTTON_LEFT))
                topElement.OnMouseDown()
            End

            If (mouse.GetDX() <> 0 Or mouse.GetDY() <> 0)
                topElement.OnMouseMove(mouse.GetDX(), mouse.GetDY())
            End
        End

        If (selectedElement And mouse.IsMouseUp(mouse.BUTTON_LEFT))
            selectedElement.OnMouseUp()
            If (topElement = selectedElement) Then selectedElement.OnMouseClick()
            selectedElement = Null
        End

        If (activeElement And Not activeElement.visible) Then activeElement = Null
    End 
End

