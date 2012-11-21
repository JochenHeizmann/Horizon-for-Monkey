Import horizon.application
Import mojo

Class UtilImage
    Function LoadStrippedImage:Image(fileName:String, frames:Int)
        If (FileType(filename) = 0) Then RuntimeError("File " + filename + " not found!")
        Local img:Image = LoadImage(filename)
        Local w:Int = ImageWidth(img)
        Local h:Int = ImageHeight(img)
        img = LoadAnimImage(filename, w / frames, h, 0, frames)
        If (Not img) Then RuntimeError("Cannot load frames of file: " + filename)
        Return img
    End Function

    Function DrawRepeated(img:Image, x:Int, y:Int, w:Int, h:Int, frame:Int = 0)
        If x < 0 Then w += x ; x = 0
        If y < 0 Then h += y ; y = 0

        Local oldViewportX:Int, oldViewportY:Int, oldViewportW:Int, oldViewportH:Int
        Local viewportX:Int, viewportY:Int, viewportW:Int, viewportH:Int

        If (x > oldViewportX) Then viewportX = x Else viewportX = oldViewportX
        If (y > oldViewportY) Then viewportY = y Else viewportY = oldViewportY
        If (oldViewportX + oldViewportW) > (viewportX + viewportW) Then viewportW = w Else viewportW = (viewportX + viewportW) - (oldViewportX + oldViewportW)
        If (h < oldViewportH) Then viewportH = h Else viewportH = oldViewportH

        Local difX:Int = (oldViewportX + oldViewportW) - (viewportX + viewportW)
        Local x2:Int = viewportX + viewportW
        Local oldX2:Int = oldViewportX + oldViewportW
        If (difX < 0) Then viewportW += difX

        Local difY:Int = (oldViewportY + oldViewportH) - (viewportY + viewportH)
        Local y2:Int = viewportY + viewportH
        Local oldY2:Int = oldViewportY + oldViewportH
        If (difY < 0) Then viewportH += difY

        If x < 0 Then viewportW += x
        If x < 0 Then viewportH += y

        Local sx% = Floor(x * Application.GetInstance().zoomFactorX) + (Application.GetInstance().translateX * Application.GetInstance().zoomFactorX)
        Local sy% = Floor(y * Application.GetInstance().zoomFactorY) + (Application.GetInstance().translateY * Application.GetInstance().zoomFactorY)
        Local dsx% = Ceil(w * Application.GetInstance().zoomFactorX) + 1 
        Local dsy% = Ceil(h * Application.GetInstance().zoomFactorY) + 1 
        SetScissor(sx,sy,dsx,dsy)
        TileImage img, x, y, w, h, frame
        SetScissor(0,0,DeviceWidth(), DeviceHeight())
    End

    Function TileImage(img:Image, x%, y%, w%, h%, frame% = 0)
        Local imgw% = img.Width()
        Local imgh% = img.Height()
        Local tx% = x
        Local ty% = y
        While (tx < (x+w))
            While (ty < (y+h))
                DrawImage img, tx, ty, frame
                ty += imgh
            Wend
            ty = y
            tx += imgw
        Wend
    End
End
