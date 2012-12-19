Import mojo
Import horizon.application

Function TileImage(img:Image, x%, y%, frame# = 0)
    Local w% = Application.GetInstance().width
    Local h% = Application.GetInstance().height
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