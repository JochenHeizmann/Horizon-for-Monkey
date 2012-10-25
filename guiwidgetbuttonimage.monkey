Import horizon.guiwidgetbutton
Import mojo
Import horizon.guisystem
Import horizon.blitzmaxfunctions

Class GuiWidgetButtonImage Extends GuiWidgetButton
    Global img:Image
    Field precalcedImage:Image

    Method New()
        img = LoadAnimImage(GuiSystem.SKIN_PATH + "requester/button.png", 43, 43, 0, 3)
        If (img = Null) Then RuntimeError("Image not found: " + GuiSystem.SKIN_PATH + "requester/button.png")
        rect.h = ImageHeight(img)
    End Method

    Method Render()
        Local frame:Int = 0
        Local off : Int = 0
        Select (GetWidgetState())
            Case HOVER
                SetColor(255,255,255)
            Case DOWN
                SetColor(168,168,168)
                off = 2
            Default
                SetColor(200,200,200)
        End

        DrawImage (img, rect.x, rect.y, 0)
        UtilImage.DrawRepeated(img, rect.x + ImageWidth(img), rect.y, rect.w - ImageWidth(img) * 2, ImageHeight(img), 1)
        DrawImage (img, rect.x + rect.w - ImageWidth(img), rect.y, 2)

        SetScale(1,1)
        If (GetWidgetState() = HOVER) Then SetColor(255,255,255) Else SetColor(192,192,192)
        font.DrawText text, off + rect.x + (rect.w / 2), off + rect.y + (rect.h / 2) - font.GetFontHeight() / 2, eDrawAlign.CENTER
        SetColor(255,255,255)
    End
End
