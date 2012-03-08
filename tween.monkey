Class Tween
	Field steps# = 100.0
	Field stp#

	Field p1#
	Field p2#

	Field val#

	Method New()
		Init()
	End

	Method Update()
		val = stp / steps
		val = ((val) * (val) * (3 - 2 * (val)))
		val = (p2 * val) + (p1 * (1 - val))
		stp += 1
		If (stp > steps) stp = steps
	End

	Method IsFinished?()
		Return (stp >= steps)
	End Method

	Method Init()
		stp = 0
		p1 = 0
		p2 = steps
		Update()
	End
End
