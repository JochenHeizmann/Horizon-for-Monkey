Import horizon.vector2d

Class Path
    Field Points:List<Vector2D>

    Method New()
        Points = New List<Vector2D>
    End Method

    Method IsPointInsideArea:Bool(x:Float, y:Float)
        Local npol:Int = Points.Count()
        Local pol := Points.ToArray()
        Local i:Int, j:Int, c:Bool
        j=npol-1
        For i=0 To npol-1
            Local ypi:Float= Point(pol[i]).y
            Local xpi:Float= Point(pol[i]).x
            Local ypj:Float= Point(pol[j]).y
            Local xpj:Float= Point(pol[j]).x
            If ((((ypi<=y) And (y<ypj)) Or ((ypj<=y) And (y<ypi))) And (x < (xpj - xpi) * (y-ypi) / (ypj - ypi) + xpi))
                c = Not c
            End If
            j = i
        Next
        Return c
    End Method

    Method AddPoint(x:Int, y:Int)
        Local p:Vector2D = New Vector2D
        p.x = x
        p.y = y
        Points.AddLast(p)
    End Method

    Method DebugPoints()
        For Local p:Vector2D = EachIn Points
            Print p.x+"/"+p.y
        Next
    End Method

    Method DrawPoints()
        Local ox:Int, oy:Int
        ox=-1
        oy=-1
        Local fx:Int, fy:Int
        For Local p:Vector2D = EachIn Points
            If ox=-1 Then fx=p.x ; fy=p.y
            If ox>-1 Then DrawLine ox,oy,p.x,p.y
            ox = p.x
            oy = p.y
        Next
        DrawLine ox,oy,fx,fy
    End Method

    Method GetNexPoint(ax:Int, ay:Int)
        Local oax:Int = ax
        Local oay:Int = ay

        Local radius:Int = 0
        Local deg:Int = 0

        While (Not IsPointInsideArea(ax,ay))
            deg += 15
            If deg >= 360 Then deg -= 360 ; radius += 4
            ax = oax + (Cos(deg) * radius)
            ay = oay + (Sin(deg) * radius)
        Wend

        Local t:Vector2D = New Point
    End Method
End