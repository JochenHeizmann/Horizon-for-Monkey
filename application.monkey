Strict

Import mojo
Import monkey
Import horizon.vector2d
Import scene
Import fader

#LIVEDEBUGGER="true"

#if LIVEDEBUGGER="true" and TARGET="html5"
	Import livedebugger
#end

Class Application Extends App

	Global application:Application
    Global updateRate% = 60

	Const SCENE_ENTERING% = 0
	Const SCENE_ACTIVE% = 1
	Const SCENE_LEAVING% = 2


	Const WAITING_IMG_SPEED# = 0.15

	Field width# = 480
	Field height# = 320

	Field state%

	Field zoomFactorX#
	Field zoomFactorY#

    Field minZoomFactorX#
    Field minZoomFactorY#

    Field translateX#
    Field translateY#

	Field scenes:StringMap<Scene>
	Field currentScene:Scene
	Field nextScene:Scene
	Field faders:List<Fader>

	Field loading?

	Field waiting?
	Field waitingImg:Image
	Field waitingFrame#

	Method OnCreate%()
		SetUpdateRate(updateRate)
		zoomFactorX = Float(DeviceWidth()) / Float(width)
		zoomFactorY = Float(DeviceHeight()) / Float(height)

        minZoomFactorX = zoomFactorX
        minZoomFactorY = zoomFactorY

		waiting = False
		Return 0
	End

	Method SetWaitingImage:Void(img:Image)
		waitingImg = img
		waitingImg.SetHandle(waitingImg.Width() / 2, waitingImg.Height() / 2)
	End

	Method SetSize:Void(w#, h#)
		width = w
		height = h
	End Method

	Method VirtualMouseX%(m%=0)
		Return (TouchX(m) / Float(zoomFactorX)) - translateX 
	End

	Method VirtualMouseY%(m%=0)
		Return (TouchY(m) / Float(zoomFactorY)) - translateY
	End

	Field leaveScene? = False
	Field enterScene? = False
	Field dontRenderFrame? = False

	Method OnUpdate%()
#if TARGET="ios" or TARGET="android"
		If (KeyDown(KEY_ESCAPE)) Then Error ""
#end

#if LIVEDEBUGGER="true" and TARGET="html5"
		If (Not LiveDebugger.GetInstance().active)
#end
			If (leaveScene)
				currentScene.OnLeave()
				leaveScene = False
				enterScene = True
				dontRenderFrame = True
			Else If (enterScene)
				SetState(SCENE_ENTERING)
				currentScene = nextScene
				currentScene.OnEnter()
				For Local f:Fader = Eachin faders
					f.FadeIn()
				Next
				enterScene = False
			Else
				currentScene.OnUpdate()
				If (state <> SCENE_ACTIVE)
					Local changeState? = True
					For Local f:Fader = Eachin faders
						If (f.IsFading())
							changeState = False
						End
						f.OnUpdate()
					Next
					If (changeState)
						If (state = SCENE_ENTERING And loading = False)
							SetState(SCENE_ACTIVE)
						Else If (state = SCENE_LEAVING)
							leaveScene = True
						End
					End
				End
			End
#if LIVEDEBUGGER="true" and TARGET="html5"
		End
#end

		If (waiting And waitingImg)
			waitingFrame += WAITING_IMG_SPEED
			If (waitingFrame > waitingImg.Frames()) Then waitingFrame -= waitingImg.Frames()
		End

#if LIVEDEBUGGER="true" and TARGET="html5"
		LiveDebugger.GetInstance().OnUpdate()
#end
    
        UpdateAsyncEvents()

		Return 0
	End

	Method SetNextScene:Void(sceneName$)
		If (nextScene)
			If (nextScene.name = sceneName) Then Return
		End
		SetState(SCENE_LEAVING)
		nextScene = scenes.Get(sceneName)
		For Local f:Fader = Eachin faders
			f.FadeOut()
		Next
	End

	Method GetState%()
		Return state
	End

	Method SetState:Void(st%)
		state = st
	End

	Method OnRender%()
		PushMatrix
		Scale(zoomFactorX, zoomFactorY)
        Translate(translateX, translateY)
		loading = False
		If (dontRenderFrame)
			dontRenderFrame = False
		Else If (currentScene)
			currentScene.OnRender()
		End If
		If (state <> SCENE_ACTIVE)
			For Local f:Fader = Eachin faders
				f.OnRender()
			Next
		End

		If (waiting)
			SetAlpha(0.6)
			SetColor(0,0,0)
			DrawRect(0,0,width,height)
			SetColor(255,255,255)
			SetAlpha(1)
			If (waitingImg)
				DrawImage (waitingImg, width / 2, height / 2, waitingFrame)
			End
		End

		PopMatrix()

#if LIVEDEBUGGER="true" and TARGET="html5"
		LiveDebugger.GetInstance().OnRender()
#end
		Return 0
	End

	Method Deactivate:Void()
		waiting = True
	End

	Method Activate:Void()
		waiting = False
	End

	Method OnLoading%()
		loading = True
		Local t$ = "Loading...Please stand by"
		SetColor(0,255, 255)
		SetAlpha(0.5)
		DrawText(t, width / 2, height - 40, .5, .5)
		Return 0
	End Method

	Method OnResume%()
		Return 0
	End Method

	Method OnSuspend%()
		Return 0
	End Method

	Function GetInstance:Application()
		If (Not application)
			application = New Application()
		End
		Return application
	End

	Method AddFader:Void(f:Fader)
		faders.AddLast(f)
	End

	Method AddScene:Void(sceneName$, scene:Scene)
		If (scenes.IsEmpty()) Then currentScene = scene
		scene.name = sceneName
		scenes.Set(sceneName, scene)
	End

	Method RemoveAllFaders:Void()
		faders.Clear()
	End

	Method Init:Void()
		faders = New List<Fader>
		scenes = New StringMap<Scene>
	End Method

	Method Run:Void()
		If (Not currentScene) Then Error("No scenes found!")
		currentScene.OnEnter()
		For Local f:Fader = Eachin faders
			f.FadeIn()
		Next
	End
End
