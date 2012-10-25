Import horizon.guiwidget
Import horizon.inputcontrollermouse

Class GuiWidgetCheckbox Extends GuiWidget
    Field checked:Bool

    Field checkboxImage:Image

    Method New()
        Local img:Image = LoadImage(GuiSystem.SKIN_PATH + "checkbox.png")
        If (img)
            img = LoadAnimImage(GuiSystem.SKIN_PATH + "checkbox.png", ImageWidth(img) / 3, ImageHeight(img), 0, 3)
            SetCheckboxImage(img)
        End If
    End Method

    Method SetCheckboxImage(img:Image)
        checkboxImage = img
        rect.w = ImageWidth(checkboxImage)
        rect.h = ImageHeight(checkboxImage)
    End Method

    Method Update()
        Super.Update()
    End Method

    Method Render()
        If (GetWidgetState() = NOTHING)
            DrawImage (checkboxImage, rect.x, rect.y)
        Else
            If (InputControllerMouse.GetInstance().IsMouseDown(InputControllerMouse.BUTTON_LEFT))
                SetColor(128, 128, 128)
                DrawImage (checkboxImage, rect.x, rect.y, 1)
                SetColor(255, 255, 255)
            Else
                DrawImage (checkboxImage, rect.x, rect.y, 1)
            End If
        End If
        If (checked)
            DrawImage (checkboxImage, rect.x, rect.y, 2)
        End If
    End Method

    Method OnMouseUp()
        Super.OnMouseUp()
        If (clicked) Then checked = Not checked
    End Method
End
