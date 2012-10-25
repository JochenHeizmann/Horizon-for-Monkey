Import horizon.rect

Class GuiBase
    Field rect : Rect
    Field visible : Bool
    Field autoRender : Bool
    Field isModal:Bool

    Field childs : List<GuiBase>

    Method Render() Abstract
    Method Update() Abstract

    Method OnMouseOver() Abstract
    Method OnMouseOut() Abstract
    Method OnMouseHit() Abstract
    Method OnMouseDown() Abstract
    Method OnRMouseDown() Abstract
    Method OnRMouseUp() Abstract
    Method OnRMouseHit() Abstract
    Method OnMouseUp() Abstract
    Method OnActivate() Abstract
    Method OnMouseMove(dx : Int, dy : Int) Abstract
    Method OnMouseClick() Abstract
    Method ToFront() Abstract
    Method ToBack() Abstract

    Method New()
        autoRender = True
        isModal = False
    End Method

    Method IsChildOf:Bool(element:GuiBase) Abstract

    Method Hide()
        visible = False
        For Local t:GuiBase = EachIn childs
            t.Hide()
        Next
    End Method

    Method Show()
        visible = True
        For Local t:GuiBase = EachIn childs
            t.Show()
        Next
    End Method

    Method SetAutoRender(aRender:Bool)
        autoRender = aRender
        For Local t:GuiBase = EachIn childs
            t.SetAutoRender(aRender)
        Next
    End Method
End
