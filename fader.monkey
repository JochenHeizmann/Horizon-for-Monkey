Strict

Class Fader
	Const FADE_OUT% = 0
	Const FADE_OFF% = 1
	Const FADE_IN% = 2

	Const DEFAULT_SPEED# = 0.05

	Field fadeState%
	Field speed#
	Field position#

	Method New()
		speed = DEFAULT_SPEED
		fadeState = FADE_IN
		position = 1
	End

	Method OnRender:Void() Abstract

	Method OnUpdate:Void()
		Select (fadeState)
			Case FADE_OUT
				position += speed
				If (position >= 1)
					position = 1
					fadeState = FADE_OFF
				End

			Case FADE_IN
				position -= speed
				If (position <= 0)
					position = 0
					fadeState = FADE_OFF
				End
		End
	End

	Method SetFadingSpeed:Void(speed#)
		Self.speed = speed
	End

	Method IsFading?()
		Return (fadeState <> FADE_OFF)
	End

	Method FadeIn:Void()
		fadeState = FADE_IN
	End

	Method FadeOut:Void()
		fadeState = FADE_OUT
	End
End