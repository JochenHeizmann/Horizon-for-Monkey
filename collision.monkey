Strict

Class Collision
	Function IntersectRect?(x1#, y1#, w1#, h1#, x2#, y2#, w2#, h2#)
		If (x1 > (x2 + w2) Or (x1 + w1) < x2) Then Return False
		If (y1 > (y2 + h2) Or (y1 + h1) < y2) Then Return False
		Return True
	End

	Function IntersectCircle?(x1#, y1#, r1#, x2#, y2#, r2#)
		Local dx#
		Local dy#
		Local distance#

		dx = x1 - x2
		dy = y1 - y2

		distance = Sqrt(Pow(dx, 2) + Pow(dy, 2))- r1 - r2
		If distance < 0.0 Then Return True
		Return False
	End
End