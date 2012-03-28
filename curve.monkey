Strict

Import horizon.vector2d
Import horizon.application

Class Curve
	Field points:IntMap<Vector2D>
	Field controlling? = False
	Field controlPoint:Vector2D
	Field pointCount%

	Field numberOfSegments% = 300
	Field segmentSize#
	Field pos# = 0
	Field speed# = 1.0

	Method New()
		pointCount = 0
		points = New IntMap<Vector2D>
		segmentSize = 1.0 / numberOfSegments
	End

	Method AddPoint:Void(x#, y#)
		points.Set(pointCount, New Vector2D(x,y))
		pointCount += 1
	End

	Method GetPoint:Vector2D(value%)
		Return points.Get(value)
	End

	Method DrawPoints:Void()
		SetColor($AA, $22, $22)
		For Local p := Eachin points.Values()
			DrawOval(p.x - 5, p.y - 5, 10, 10)
		Next
	End

	Method CalculateSharedPoints:Void()
		For Local i% = 2 To pointCount-2
			points.Get(i-1).x = points.Get(i-1).x + ((points.Get(i+1).x - points.Get(i-1).x) * 0.5)
			points.Get(i-1).y = points.Get(i-1).y + ((points.Get(i+1).y - points.Get(i-1).y) * 0.5)
		Next
	End

	Method DrawLines:Void()
		SetColor($88, $88, $88)
		Local lastPoint:Vector2D = Null
		For Local p := Eachin points.Values()
			If (lastPoint)
				DrawLine(lastPoint.x, lastPoint.y, p.x, p.y)
			End
			lastPoint = p
		Next
	End

	Method Update:Void()
		Local mx%, my%
		mx = Application.GetInstance().VirtualMouseX()
		my = Application.GetInstance().VirtualMouseY()

		If (Not controlling)
			If (MouseDown())
				For Local p := Eachin points.Values()
					If (mx > p.x - 15 And my > p.y - 15 And mx < p.x + 15 And my < p.y + 15)
						controlling = True
						controlPoint = p
					End
				Next
			Else
				controlling = False
			End
		End

		If (controlling)
			Local ox% = controlPoint.x
			Local oy% = controlPoint.y

			controlPoint.x = mx
			controlPoint.y = my

			Local dx% = controlPoint.x - ox
			Local dy% = controlPoint.y - oy

			For Local i% = 2 To pointCount
				If (i Mod 2 = 0)
					If (points.Get(i) = controlPoint)
						'MoveCurve(dx, dy, i)
					End
				End
			End

			If (Not MouseDown()) Then controlling = False
		End
	End

	Method DrawSegments:Void()
		Local pp# = 0
		Local ox% = -900
		Local oy% = 0
		Local firstPoint? = True
		While (pp < ((pointCount-1) / 2) - 0.1)
			pp += segmentSize * 10
			Local p:Vector2D = GetPosition(pp)
			If (ox <> -900) Then DrawLine(ox, oy, p.x, p.y)
			ox = p.x
			oy = p.y
		Wend
	End

	Method MoveCurve:Void(dx%, dy%, point%)
		For Local i% = 1 To pointCount-2
			If (i <> point)
				points.Get(i).x += dx
				points.Get(i).y += dy
			End
		Next
	End

	Method ToString$()
		Local s$
		For Local p:Vector2D = Eachin points.Values()
			s += "curve.AddPoint(" + Int(p.x) + ", " + Int(p.y) + ")~n"
		Next
		Return s
	End

	Method GetPosition:Vector2D(pos#)
		Local point% = (Floor(pos) Mod ((pointCount-1) / 2) * 2)
		pos = pos Mod 1
		Local p1:Vector2D = GetPoint(point)
		Local p2:Vector2D = GetPoint(point + 1)
		Local p3:Vector2D = GetPoint(point + 2)

		Local p12x# = (p2.x-p1.x) * pos
		Local p12y# = (p2.y-p1.y) * pos
		Local p23x# = (p3.x-p2.x) * pos
		Local p23y# = (p3.y-p2.y) * pos
		Local p:Vector2D = New Vector2D
		p.x = (((p2.x+p23x) - (p1.x+p12x)) * pos) + p1.x + p12x
		p.y = (((p2.y+p23y) - (p1.y+p12y)) * pos) + p1.y + p12y
		Return p
	End
End