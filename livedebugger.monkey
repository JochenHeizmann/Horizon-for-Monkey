Strict

Import reflection
Import mojo
Import horizon.scene
Import horizon.application
Import horizon.touchcontroller
Import toddler.sprite

Class DebugEntry
	Field name$
	Field f:FieldInfo
	Field o:Object
	Field y%

	Method UpdateName:Void()
		name = f.Name() + ":" + GetTypeName(f) + " = " + GetValue(o, f)
	End

	Method GetTypeName$(cField:FieldInfo)
		Local ret$ = cField.Type.Name()
		ret = ret.Replace("monkey.boxes.IntObject", "Int")
		ret = ret.Replace("monkey.boxes.FloatObject", "Float")
		ret = ret.Replace("monkey.boxes.StringObject", "String")
		ret = ret.Replace("monkey.boxes.BoolObject", "Bool")
		ret = ret.Replace("monkey.boxes.ArrayObject", "Array")
		Return ret
	End

	Method GetValue$(obj:Object, f:FieldInfo)
		Select f.Type().Name()
			Case "monkey.boxes.IntObject"
				Return String(UnboxInt(f.GetValue(obj)))

			Case "monkey.boxes.FloatObject"
				Return String(UnboxFloat(f.GetValue(obj)))

			Case "monkey.boxes.StringObject"
				Return UnboxString(f.GetValue(obj))

			Case "monkey.boxes.BoolObject"
				If UnboxBool(BoolObject(f.GetValue(obj)))
					Return "True"
				Else
					Return "False"
				End

			Default
				Return "#"
		End
	End

End

Class LiveDebugger
	Const LINE_HEIGHT% = 13

	Global instance:LiveDebugger

	Field active?
	Field baseObject:Object
	Field ty%

	Field entries:List<DebugEntry>

	Function GetInstance:LiveDebugger()
		If (Not instance)
			instance = New LiveDebugger()
		End
		Return instance
	End

	Method New()
		active = false
		entries = New List<DebugEntry>
		baseObject = Null
	End

	Method OnUpdate:Void()
		If (KeyHit(KEY_TAB) Or (TouchDown(0) And TouchDown(1) And TouchDown(2)))
			active = Not active
			InitObjectList(baseObject)
			selected = Null
			startDrag = False
		End

		If (active And startDrag)
			Local dx% = Application.GetInstance().VirtualMouseX()-oldX
			Local dy% = Application.GetInstance().VirtualMouseY()-oldY
			If (selected)
				If (selected.name = "..")
					InitObjectList()
				Else
					Select selected.f.Type.Name()
						Case "monkey.boxes.IntObject"
							selected.f.SetValue(baseObject, BoxInt(UnboxInt(selected.f.GetValue(baseObject)) + dx))
							selected.UpdateName()

						Case "monkey.boxes.FloatObject"
							Local val# = UnboxFloat(selected.f.GetValue(baseObject))
							If val >= -1.5 And val <= 1.5
								selected.f.SetValue(baseObject, BoxFloat(val + Float(dx) / 100.0 ))
							Else
								selected.f.SetValue(baseObject, BoxFloat(val + Float(dx) ))
							End
							selected.UpdateName()

						Case "monkey.boxes.BoolObject"
							selected.f.SetValue(baseObject, BoxBool(Not UnboxBool(selected.f.GetValue(baseObject))))
							selected.UpdateName()
							selected = Null

						Default
							baseObject = selected.f.GetValue(baseObject)
							If (selected.o) Then baseObject = selected.o
							selected = Null
							InitObjectList(baseObject)

					End
				End
			Else If (GetClass(baseObject).Name() = "toddler.sprite.Sprite" Or GetClass(baseObject).SuperClass().Name() = "toddler.sprite.Sprite")
				Sprite(baseObject).x += dx
				Sprite(baseObject).y += dy
			End
			oldX = Application.GetInstance().VirtualMouseX()
			oldY = Application.GetInstance().VirtualMouseY()

			If (Not TouchDown())
				startDrag = False
				selected = Null
                InitObjectList(baseObject)
			End
		End
	End

	Field oldX%, oldY%

	Method InitObjectList:Void(parent:Object = Null)
		Local y% = 0
		entries.Clear()

		If (parent)
			Local e:DebugEntry = New DebugEntry
			e.o = baseObject
			e.y = y
			e.name = ".."
			y += LINE_HEIGHT
			entries.AddLast(e)
		Else
			baseObject = Application.GetInstance().currentScene
		End
		If (baseObject)
			Local cInfo:ClassInfo = GetClass(baseObject)
			For Local cField := Eachin cInfo.GetFields(True)
				Select cField.Type.Name()
					Case "monkey.boxes.ArrayObject<toddler.sprite.Sprite>"
						Print cField.Type.Name()
						Local v := ArrayBoxer<Sprite>.Unbox(cField.GetValue(baseObject))
						Local c%
						If (v)
							For Local o:=Eachin v
								Local e:DebugEntry = New DebugEntry
								e.f = cField
								e.o = o
								e.y = y
								e.name = "Array<Sprite>[" + c + "]"
								entries.AddLast(e)
								y += LINE_HEIGHT
								c+=1
							Next
						End

					Case "monkey.boxes.StringObject", "monkey.boxes.IntObject", "monkey.boxes.FloatObject", "monkey.boxes.BoolObject", "monkey.boxes.lang.object"
						Local e:DebugEntry = New DebugEntry
						e.f = cField
						e.o = baseObject
						e.y = y
						e.UpdateName()
						entries.AddLast(e)
						y += LINE_HEIGHT

					Default
						Local e:DebugEntry = New DebugEntry
						e.f = cField
						e.o = cField.GetValue(baseObject)
						e.y = y
						e.UpdateName()
						entries.AddLast(e)
						y += LINE_HEIGHT
				End
			Next
		End
	End

	Field selected:DebugEntry
	Field startDrag?

	Method OnRender:Void()
		If (active)
			SetAlpha(0.9)
			For Local e:=Eachin entries
				Local hover? = False
				If (Not selected And MouseY() > e.y And  MouseY() < e.y + LINE_HEIGHT) Then hover = True
				If (hover)
					If (TouchDown() And Not startDrag)
						startDrag = True
						oldX = Application.GetInstance().VirtualMouseX()
						oldY = Application.GetInstance().VirtualMouseY()
						selected = e
					End
					SetColor(0,255,255)
				Else
					SetColor(255,255,255)
				End
				If (e = selected) Then SetColor(255,0,0)
				DrawText(e.name, 0, e.y)
			Next
			SetAlpha(1)

			If Not selected And Not startDrag
				If GetClass(baseObject).SuperClass.Name() = "toddler.sprite.Sprite" Or GetClass(baseObject).Name() = "toddler.sprite.Sprite"
					If Not startDrag And TouchDown()
						oldX = Application.GetInstance().VirtualMouseX()
						oldY = Application.GetInstance().VirtualMouseY()
					 	startDrag = True
					End
				End
			End

		End
	End

End