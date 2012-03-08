Strict

Import horizon.scene

Import mojo.graphics
Import mojo.app
Import horizon.application

Class SceneSplashScreen Extends Scene
	Field img:Image
	Field imgFile$

	Field nextScene$

	Field duration%
	Field start%

	Method New(imageFile$, duration%, nextScene$)
		Self.imgFile = imageFile
		Self.duration = duration
		Self.nextScene = nextScene
	End

	Method OnEnter:Void()
		img = LoadImage(imgFile)
		start = Millisecs()
	End Method

	Method OnLeave:Void()
		img = Null
	End Method

	Method OnUpdate:Void()
		If duration = 0
			If TouchHit()
				Application.GetInstance().SetNextScene(nextScene)
			End
		Else If (start + duration < Millisecs())
			Application.GetInstance().SetNextScene(nextScene)
		End
	End Method

	Method OnRender:Void()
		DrawImage(img, 0, 0)
	End Method
End

