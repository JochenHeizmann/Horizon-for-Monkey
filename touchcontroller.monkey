Strict

Import mojo.input
Import application

Class TouchController
	Global instance:TouchController

	Function GetInstance:TouchController()
		If (Not instance) Then instance = New TouchController
		Return instance
	End

	Field isDown?
	Field wasDown?

	Field startX%
	Field startY%
	Field dx%, dy%


	Method Update:Void()
		wasDown = isDown

		If (TouchDown() And Not isDown)
			isDown = True
			startX = Application.GetInstance().VirtualMouseX()
			startY = Application.GetInstance().VirtualMouseY()
		End

		If (Not TouchDown() And isDown)
			isDown = False
			dx = Application.GetInstance().VirtualMouseX() - startX
			dy = Application.GetInstance().VirtualMouseY() - startY
		End
	End

	Method GetDX#()
		Return Application.GetInstance().VirtualMouseX() - startX
	End

	Method GetDY#()
		Return Application.GetInstance().VirtualMouseY() - startY
	End

	Method IsTouchUp?()
		Return (Not isDown And wasDown)
	End

	Method IsTouchDown?()
		Return isDown
	End

	Method WasTouchedDown?()
		Return wasDown
	End

	Method GetLastSlideDistance#()
		Return (Sqrt(dx * dx + dy * dy))
	End
End