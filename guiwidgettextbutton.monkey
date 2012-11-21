
Import horizon.guiwidget
Import horizon.inputcontrollermouse
Import horizon.utilimage

Class GuiWidgetTextButton Extends GuiWidget
    
    Field img:Image
    Field text$
    
    Function Create:GuiWidgetTextButton(imageFilename$, x%, y%, w%)
        Local instance:GuiWidgetTextButton = New GuiWidgetTextButton
        instance.rect.x = x
        instance.rect.y = y
        Local tmpImg:Image = LoadImage(imageFilename)
        If (Not tmpImg) Then Error("Image " + imageFilename + " couldn't be loaded!")
        Local frameWidth% = (tmpImg.Width) / 3
        Local frameHeight% = tmpImg.Height
        instance.rect.w = w
        instance.rect.h = frameHeight
        instance.img = LoadImage(imageFilename, frameWidth, frameHeight, 3)
        Return instance
    End    
    
    Method SetText(text$)
        Self.text = text
    End
    
    Method Render()
        Local frame% = 0
        Select (GetWidgetState())
            Case HOVER
                SetAlpha(1)
                SetColor(255,255,255)
                
            Case DOWN
                SetAlpha(1)
                SetColor(100,100,100)
                
            Default
                SetAlpha(1)
                SetColor(200,200,200)
        End 
        
        DrawImage img, rect.x, rect.y, 0
        UtilImage.DrawRepeated(img, rect.x + img.Width, rect.y, rect.w - img.Height * 2, rect.h, 1)
        DrawImage img, rect.x + rect.w - (img.Width), rect.y , 2
        
        SetColor(255,0,0)
        DrawText(text, rect.x, rect.y)
        
        SetAlpha(1)
        SetColor(255,255,255)    
    End     
End 
