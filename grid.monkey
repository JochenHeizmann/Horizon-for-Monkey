Strict

Class Grid
	Field width%
	Field height%
	Field boardSize%

	Field data%[]

	Method New(w%, h%, initValue% = 0)
		width = w
		height = h
		boardSize = w * h
		data = New Int[boardSize]
		For Local i% = 0 To boardSize-1
			data[i] = initValue
		Next
	End

	Method GetCount%[](val%)
		Local c% = 0
		For Local i% = 0 To boardSize-1
			If (data[i] = val)
				c += 1
			End
		Next
		Return c
	End

	Method Set:Void(x%, y%, value%)
		If (x < 0 Or y < 0 Or x >= width Or y >= height) Then Error("Index out of range! (" + x + "/" + y + ")")
		data[y * width + x] = value
	End

	Method Get%(x%, y%)
		If (x < 0 Or y < 0 Or x >= width Or y >= height) Then Error("Index out of range! (" + x + "/" + y + ")")
		Return data[y * width + x]
	End

	Method IsDataEqual?(d%[])
		If (data.Length() <> d.Length()) Then Return False
		For Local i% = 0 To boardSize-1
			If (data[i] <> d[i]) Then Return False
		Next
		Return True
	End

	Method Clone:Grid()
		Local g:Grid = New Grid(width, height)
		For Local x% = 0 To width-1
			For Local y% = 0 To height-1
				g.Set(x,y, Get(x,y))
			Next
		Next
		Return g
	End

	Method SlideToLeft?(y%)
		If (y < 0 Or y >= height) Then Return False
		Local temp% = Get(0, y)
		For Local x% = 0 To width-2
			Set(x, y, Get(x + 1, y))
		Next
		Set(width-1, y, temp)
		Return True
	End

	Method SlideToRight?(y%)
		If (y < 0 Or y >= height) Then Return False
		Local temp% = Get(width-1, y)
		For Local x% = width-1 To 1 Step -1
			Set(x,y,Get(x-1,y))
		Next
		Set(0, y, temp)
		Return True
	End

	Method SlideUp?(x%)
		If (x < 0 Or x >= width) Then Return False
		Local temp% = Get(x, 0)
		For Local y% = 0 To height-2
			Set(x,y,Get(x,y+1))
		Next
		Set(x, height-1, temp)
		Return True
	End

	Method SlideDown?(x%)
		If (x < 0 Or x >= width) Then Return False
		Local temp% = Get(x, height-1)
		For Local y% = height-1 To 1 Step -1
			Set(x,y,Get(x,y-1))
		Next
		Set(x,0,temp)
		Return True
	End
End