
Import horizon.guiwidgetframe
Import horizon.color
Import horizon.guisystem
Import horizon.blitzmaxfunctions

Class GuiWidgetTextbox Extends GuiWidgetFrame

    Field PADDING:Int = 2

    Field font:BitmapFont

    Field multiline:Bool = False
    Field text:String
    Field maxLen : Int
    Field cPos : Int
    Field cursorJump:Bool
    Field allowedChars:String
    Field textColor:Color

    Field keyboard?

    Function CreateTextbox : GuiWidgetTextbox(x:Int, y:Int, w:Int, h:Int)
        Local t:GuiWidgetTextbox = New GuiWidgetTextBox
        t.rect.x = x
        t.rect.y = y
        t.rect.w = w
        t.rect.h = h
        t.style = 0
        t.text = ""
        Return t
    End Function

    Method SetText(t:String)
        text = t[0..maxLen+1]
    End Method

    Method New()
        keyboard = False
        topBar = LoadImage(GuiSystem.SKIN_PATH + "window/bottomborder.png")
        rightBorder = LoadImage(GuiSystem.SKIN_PATH + "window/rightborder.png")
        leftBorder = LoadImage(GuiSystem.SKIN_PATH + "window/leftborder.png")
        bottomBorder = LoadImage(GuiSystem.SKIN_PATH + "window/bottomborder.png")
        maxLen = 10000
        allowedChars = ""
        textColor = Color.Create(0,0,0)
    End Method

    Method Render()
        SetScissor(GetInnerWindowX() * Application.GetInstance().zoomFactorX, GetInnerWindowY() * Application.GetInstance().zoomFactorY, GetInnerWidth() * Application.GetInstance().zoomFactorX, GetInnerHeight() * Application.GetInstance().zoomFactorY)
        If (GuiSystem.activeElement = Self)
            SetColor($AA,$AA,$AA)
        Else
            SetColor($88,$88,$88)
            If (GetWidgetState() = HOVER) Then SetColor($99,$99,$99)
        End If

        Local x : Int = GetInnerWindowX()
        Local y : Int = GetInnerWindowY()
        DrawRect x,y, GetInnerWidth(), GetInnerHeight()
        x += PADDING
        y += PADDING
        For Local pos:Int = -1 To text.Length
            If pos >= 0
                SetColor(textColor.r, textColor.g, textColor.b)
                Local char:String = Mid(text, pos, 1)

                Local break : Bool = False
                Local tmpX : Int = x
                Local boundX : Int = GetInnerWindowX() + GetInnerWidth()
                Local c : Int = 0
                While (pos + c <= text.Length)
                    Local nc : String = Mid(text, pos + c, 1)
                    c += 1
                    tmpX += font.GetTxtWidth(nc) * 0.9
                    If tmpX >= boundX Then break = True ; Exit
                    If nc = " " Then Exit
                Wend
                If break Or char = CHAR_ENTER
                    y += font.GetFontHeight()
                    x = GetInnerWindowX() + PADDING
                End If

                font.DrawText char, x, y
                x += font.GetTxtWidth(char) * 0.9
            End

            If (GuiSystem.activeElement = Self And cPos = pos And Millisecs() / 400 Mod 2 = 0)
                SetColor(255 - textColor.r, 255 - textColor.g, 255 - textColor.b)
                SetColor(0, 0, 0)
                If cPos = text.Length-1
                    DrawRect x+2,y, 1, font.GetFontHeight()-3
                Else
                    DrawRect x,y, 1, font.GetFontHeight()-3
                End If
            End If

            If (cursorJump)
                If (GuiSystem.mouse.GetX() > x And GuiSystem.mouse.GetY() > y)
                    cPos = pos
                    If cPos > text.Length-1 Then cPos = text.Length-1
                End If
            End If

            If (pos >= maxLen) Then Exit
        Next
        SetColor(255,255,255)
        Super.Render()
        SetScissor(0,0,DeviceWidth(), DeviceHeight())
    End Method

    Method CursorToEnd()
        cPos = text.Length-1
    End Method

    Method DrawTopBar()
        UtilImage.DrawRepeated(topBar, GetX(), GetY(), rect.w, ImageHeight(topBar))
    End Method

    Method GetInnerHeight : Int()
        Return rect.h - ImageHeight(topBar) - ImageHeight(bottomBorder)
    End Method

    Method DrawBottomBorder()
        UtilImage.DrawRepeated(bottomBorder, GetX(), GetY() + rect.h - ImageHeight(bottomBorder), rect.w, ImageHeight(bottomBorder))
    End Method

    Method Update()
        cursorJump = False
        Super.Update()

        If (Self = GuiSystem.activeElement)
            If (Not keyboard)
                keyboard = True
                EnableKeyboard()
            End 

            If KeyHit(CHAR_LEFT)
                cPos -= 1
                If cPos < 0 Then cPos = 0
            End

            If KeyHit(CHAR_RIGHT)
                cPos += 1
                If cPos > text.Length-1 Then cPos = text.Length-1
            End If

            If KeyHit(CHAR_DELETE) And cPos < text.Length-1 Then RemoveChar(cPos+1) ; cPos += 1
            If KeyHit(CHAR_HOME) Then cPos = 0
            If KeyHit(CHAR_END) Then cPos = text.Length-1

            Local c:Int = GetChar()
            While (c > 0)
                Select c
                    Case CHAR_BACKSPACE
                        RemoveChar(cPos)

                    Case CHAR_ENTER
                        If (multiline)
                            InsertChar(String.FromChar(c))
                        Else
                            GuiSystem.activeElement = Null
                        End If

                    Default
                        InsertChar(String.FromChar(c))
                End Select

                c = GetChar()
            Wend
        Else
            If (keyboard)
                keyboard = False
                DisableKeyboard()
            End 
        End
    End Method

    Method InsertChar(c:String)
        If text.Length >= maxLen Then Return

        If allowedChars <> ""
            Local found:Bool = False
            For Local i:Int = 0 To allowedChars.Length
                If Mid(allowedChars, i, 1) = c Then found = True ; Exit
            Next
            If (Not found) Then Return
        End If

        Local firstSegment : String = Mid(text, 0, cPos + 1)
        text = firstSegment + c + Right(text, text.Length - firstSegment.Length)
        cPos += 1
    End Method

    Method RemoveChar(pos:Int)
        If text.Length > 0 And cPos >= 0
            Local firstSegment : String = Mid(text, 0, pos)
            text = firstSegment + Right(text, text.Length - firstSegment.Length - 1)
            cPos -= 1
        End If
    End Method

    Method OnActivate()
        Super.OnActivate()
    End Method

    Method OnMouseHit()
        GuiSystem.activeElement = Self
        cursorJump = True
    End Method
End
