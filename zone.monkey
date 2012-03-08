Strict

Import vector2d
Import collision

Class Zone
	Field p:Vector2D[2]

	Method New(x1%, y1%, x2%, y2%)
		Init()
		p[0].x = x1
		p[0].y = y1
		p[1].x = x2
		p[1].y = y2
	End

	Method Init:Void()
		p[0] = New Vector2D(0,0)
		p[1] = New Vector2D(0,0)
	End

	Method InZone?(x%, y%, w% = 1, h% = 1)
		Return Collision.IntersectRect(p[0].x,p[0].y,p[1].x - p[0].x,p[1].y - p[0].y,x,y,w,h)
	End
End