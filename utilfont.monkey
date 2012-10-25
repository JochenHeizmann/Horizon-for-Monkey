Import mojo
Import fontmachine
Import horizon.application

Class UtilFont
    Const KEY_ENTER% = CHAR_ENTER

    Function Draw(font:BitmapFont, txt:String, x:Int, y:Int, boxWidth:Int, lineHeight:Float = 1.0)
        Local sy:Int = y

        For Local f2line:String = EachIn txt.Split("~n")
            For Local line:String = EachIn f2line.Split(KEY_ENTER)
                If (font.GetTxtWidth(line) > boxWidth)
                    Local px:Int = x
                    For Local word:String = EachIn line.Split(" ")
                        If (font.GetTxtWidth(word) + px > x + boxWidth)
                            y += font.GetFontHeight() * lineHeight
                            px = x
                        End If
                        font.DrawText (word + " ", px, y)
                        px += font.GetTxtWidth(word + " ")
                    Next
                Else
                    font.DrawText line, x, y
                End If
                y += font.GetFontHeight() * lineHeight
            Next
        Next
    End Function

    Function GetHeight:Int(font:BitmapFont, txt:String, boxWidth:Int, lineHeight:Float = 1.0)
        Local x:Int = 0
        Local y:Int = 0

        For Local f2line:String = EachIn txt.Split("~n")
            For Local line:String = EachIn f2line.Split(CHAR_ENTER)
                If (font.GetTxtWidth(line) > boxWidth)
                    Local px:Int = x
                    For Local word:String = EachIn line.Split(" ")
                        If (font.GetTxtWidth(word) + px > x + boxWidth)
                            y += font.GetFontHeight() * lineHeight
                            px = x
                        End If
                        px += font.GetTxtWidth(word + " ")
                    Next
                End If
                y += font.GetFontHeight() * lineHeight
            Next
        Next
        Return y
    End Function
End
