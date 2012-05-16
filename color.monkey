Strict

Import mojo

Class Color
	Field r%, g%, b%

	Method New(r% = 255, g% = 255, b% = 255)
		Self.r = r
		Self.g = g
		Self.b = b
	End

	Method Set:Void()
		SetColor(r, g, b)
	End
End
