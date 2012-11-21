
Class Rect
    Field x%, y%
    Field w%, h%

    Method New(x% = 0, y% = 0, w% = 0, h% = 0)
        Self.x = x
        Self.y = y
        Self.w = w
        Self.h = h
    End

    Method GetX2%()
        Return x + w
    End
    
    Method GetY2%()
        Return y + h
    End
    
    Method GetX%()
        Return x
    End
    
    Method GetY%()
        Return y
    End
    
    Method GetW%()
        Return w
    End
    
    Method GetH%()
        Return h
    End
    
    Method IsInRect?(x%, y%)
        Return (x >= GetX() And y >= GetY() And x <= GetX2() And y <= GetY2())
    End    
    
    Method Move(dx%, dy%)
        x += dx
        y += dy
    End
    
    Method SetXY(x%, y%)
        Self.x = x
        Self.y = y
    End
    
    Method SetWidth(w%)
        Self.w = w
    End
    
    Method SetHeight(h%)
        Self.h = h
    End
End
