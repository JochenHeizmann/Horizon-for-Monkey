Strict

Class Vector2D
	Field x#, y#

	Method New(x# = 0, y# = 0)
		Self.x = x
		Self.y = y
	End

	Method Rotate:Void(angle#)
		Local x2# = (x * Cos(angle)) - (y * Sin(angle))
		Local y2# = (y * Cos(angle)) - (x * Sin(angle))
		x = x2
		y = y2
	End

	Method Magnitude#()
		Return Sqrt(x * x + y * y)
	End

	Method Normalize#()
		Local mag# = Magnitude()

		If (mag <> 00)
			x /= mag
			y /= mag
		End

		Return mag
	End

	Method DotProduct#(v2:Vector2D)
		Return (x * v2.x) + (y * v2.y)
	End

	Method CrossProduct#(v2:Vector2D)
		Return (x * v2.y) - (y * v2.x)
	End

	Function Zero:Vector2D()
		Return New Vector2D(0,0)
	End

	Function Distance#(v1:Vector2D, v2:Vector2D)
		Return Sqrt((v2.x - v1.x), 2) + Pow((v2.y - v1.y), 2)
	End

	Function Equal?(v1:Vector2D, v2:Vector2D)
		Return (v1.x = v2.x And v1.y = v2.y)
	End

	Method Add:Void(v2:Vector2D)
		x += v2.x
		y += v2.y
	End

	Method Sub:Void(v2:Vector2D)
		x -= v2.x
		y -= v2.y
	End

	Method Mul:Void(v2:Vector2D)
		x *= v2.x
		y *= v2.y
	End

	Method Div:Void(v2:Vector2D)
		x /= v2.x
		y /= v2.y
	End

	Function Add:Vector2D(v1:Vector2D, v2:Vector2D)
		Return New Vector2D(v1.x + v2.x, v1.y + v2.y)
	End

	Function Sub:Vector2D(v1:Vector2D, v2:Vector2D)
		Return New Vector2D(v1.x - v2.x, v1.y - v2.y)
	End

	Function Mul:Vector2D(v1:Vector2D, v2:Vector2D)
		Return New Vector2D(v1.x * v2.x, v1.y * v2.y)
	End

	Function Div:Vector2D(v1:Vector2D, v2:Vector2D)
		Return New Vector2D(v1.x / v2.x, v1.y / v2.y)
	End

	Method IsZero?()
		Return (x = 0 And y = 0)
	End
End
