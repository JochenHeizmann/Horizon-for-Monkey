Import horizon.guisystem
Import horizon.guibase
Import horizon.rect
Import horizon.color

Class GuiWidget Extends GuiBase

    Global idCounter : Int

    Const NOTHING : Int = 0
    Const HOVER : Int = 1
    Const DOWN : Int = 2

    Field widgetState : Int

    Field id : Int

    Field parent : GuiWidget

    Field color : Color

    Field clicked : Bool
    Field entered:Bool

    Method IsChildOf:Bool(element:GuiBase)
        If (Not element) Then Return True
        If (parent)
            If (parent = element) Then Return True
            Return parent.IsChildOf(element)
        End If
        Return False
    End Method

    'dirty helper method because of time pressure, sorry
    Method IsMouseEntered:Bool()
        Local ret:Bool = entered
        entered = False
        Return (ret)
    End Method

    Method New()
        Super.New()
        idCounter += 1
        id = idCounter
        visible = True
        childs = New List<GuiBase>
        rect = New Rect(0, 0, 100, 100)
        color = New Color(255, 255, 255)
        GuiSystem.widgets.AddLast(Self)
    End Method

    Method ToFront()
        Local root:GuiBase = GetRootParent(Self.parent)
        If root
            GuiWidget(root).ChildsToFront()
        Else
            ChildsToFront()
        EndIf
    End Method

    Function GetRootParent:GuiBase(widget:GuiBase)
        If widget
            Local root:GuiBase
            While widget
                root = widget
                widget = GuiWidget(root).parent
            Wend
            Return root
        EndIf
        Return Null
    End Function

    Method ChildsToFront()
            GuiSystem.widgets.Remove(Self)
            GuiSystem.widgets.AddLast(Self)
            For Local c : GuiBase = EachIn childs
                If GuiWidget(c) Then GuiWidget(c).ChildsToFront()
            Next
    End Method

    Method ToBack()
        GuiSystem.widgets.Remove(Self)
        For Local c : GuiBase = EachIn childs
            c.ToBack()
        Next
        GuiSystem.widgets.AddFirst(Self)
    End Method

    Method OnActivate()
        ToFront()
    End Method

    Method Render()
    End Method

    Method AddChild(w : GuiWidget)
        If (w.parent) Then w.parent.RemoveChild(w)
        childs.AddLast(w)
        w.parent = Self
    End Method

    Method RemoveChild(w : GuiWidget)
        childs.Remove(w)
        w.parent = Null
    End Method

    Method Update()
        clicked = False        
        #if TARGET="flash" or TARGET="html5"
        If (Not TouchDown(1))
            If GuiSystem.topElement <> Self Then widgetState = NOTHING Else widgetState = HOVER
        End If
        #else
            If (Not TouchDown(0))
                widgetState = NOTHING
            End If
        #end
    End Method

    Method GetWidgetState : Int()
        Return widgetState
    End Method

    Method OnMouseHit()
        clicked = True
        widgetState = DOWN
    End Method

    Method OnMouseUp()
        widgetState = NOTHING
        If (GuiSystem.topElement = Self) Then widgetState = HOVER
    End Method

    Method IsClicked : Bool()
        Return clicked
    End Method

    Method OnMouseOut()
        If (widgetState = HOVER) Then widgetState = NOTHING
        entered = False
    End Method

    Method OnMouseOver()
        If (widgetState = NOTHING) Then widgetState = HOVER
        entered = True
    End Method

    Method OnMouseMove(dx : Int, dy : Int)
    End Method

    Method OnMouseDown()
    End Method

    Method OnRMouseDown()
    End Method

    Method OnMouseClick()
    End Method

    Method OnMove()
        rect.Move(-InputControllerMouse.GetInstance().GetDX(), -InputControllerMouse.GetInstance().GetDY())
    End Method

    Method OnRMouseHit()
    End Method

    Method OnRMouseUp()
    End Method

    Method Hide()
        Super.Hide()
        clicked = False
    End Method
End

