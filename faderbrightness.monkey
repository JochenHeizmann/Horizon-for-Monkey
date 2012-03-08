Strict

Import mojo
Import fader
Import application

Class FaderBrightness Extends Fader
	Method OnRender:Void()
		Local alpha# = GetAlpha()
		Local c#[] = GetColor()

		Scale(1,1)
		SetAlpha(position)
		SetColor(0,0,0)
		Rotate(0)

		DrawRect(0,0, Application.GetInstance().width, Application.GetInstance().height)

		SetColor(c[0], c[1], c[2])
		SetAlpha(alpha)
	End
End