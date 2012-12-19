Import tileset
Import tiledmap
Import horizon.application
Import horizon.rect
Import layerrenderer
Import specialtile
Import maptype
Import mapobject

Class MapLayer
    Field data%[][]

    Field width%
    Field height%

    Field x%
    Field y%

    Field name$

    Field opacity#

    Field type%

    Field visible?

    Field properties:StringMap<String>

    Field factorHoriz#
    Field factorVert#

    Field loopMode?

    Field parentMap:TiledMap

    Field renderer:LayerRenderer

    Global defaultRenderer:LayerRenderer

    Field specialTiles:IntMap<SpecialTile>
    Field specialTilesList:IntList

    Field objects:List<MapObject>

    Method New(parentMap:TiledMap)
        Self.parentMap = parentMap
        properties = New StringMap<String>
        specialTiles = New IntMap<SpecialTile>
        specialTilesList = New IntList
        factorHoriz = 1.0
        factorVert = 1.0
        loopMode = False
        renderer = GetDefaultRenderer()
        objects = New List<MapObject>
    End

    Function GetDefaultRenderer:LayerRenderer()
        If Not defaultRenderer
            defaultRenderer = New LayerRenderer
        End
        Return defaultRenderer
    End

    Method CopyGrid:Int[][]()
        Local copiedData := ArrayUtil2D<Int>.CreateArray(width, height)
        For Local x% = 0 To width-1
            For Local y% = 0 To height-1
                copiedData[x][y] = data[x][y]
            Next
        Next
        Return copiedData
    End

    Method AssignSpecialTile(mx%, my%, st:SpecialTile, removeOriginal? = True, firstEntry? = False)
        specialTiles.Set(my * width + mx, st)
        If (firstEntry)
            specialTilesList.AddFirst(my * width + mx)
        Else
            specialTilesList.AddLast(my * width + mx)
        End
        If removeOriginal Then SetTile(mx, my, 0)
    End

    Method RemoveSpecialTile(mx%, my%)
        specialTilesList.Remove(my * width + mx)
        specialTiles.Remove(my * width + mx)
    End

    Method GetSpecialTile:SpecialTile(mx%, my%)
        Return specialTiles.Get(my * width + mx)
    End

    Method GetCurrentViewport:Rect()
        Local startX% = GetOffsetX() / parentMap.tileWidth - 1
        Local startY% = GetOffsetY() / parentMap.tileHeight - 1
        Local endX% = startX + (Application.GetInstance().width / parentMap.tileWidth) + 2
        Local endY% = startY + (Application.GetInstance().height / parentMap.tileHeight) + 2
        
        If Not loopMode
            If (startX < 0) Then startX = 0
            If (startY < 0) Then startY = 0
            If (endX >= width) Then endX = width-1
            If (endY >= height) Then endY = height-1
        End

        Return New Rect(startX, startY, endX - startX, endY - startY)
    End

    Method Render:Void()
        If Not visible Then Return

        Local viewport := GetCurrentViewport()

        For Local x% = viewport.x To viewport.x + viewport.w
            For Local y% = viewport.y To viewport.y + viewport.h

                Local gx% = x 
                If (gx < 0) Then gx = width - (Abs(gx) Mod width)
                gx = gx Mod width

                Local gy% = y
                If (gy < 0) Then gy = height - (Abs(gy) Mod height)
                gy = gy Mod height

                If (data[gx][gy] > 0)
                    Local tx% = x * parentMap.tileWidth - GetOffsetX()
                    Local ty% = y * parentMap.tileHeight - GetOffsetY()

                    Local tiles := parentMap.GetTilesetForTileId(data[gx][gy])

                    renderer.Render(data[gx][gy] - tiles.firstGID, tiles.tiles, tx, ty, data[gx][gy], gx, gy)
                End
            Next
        Next

        RenderObjects()
        RenderSpecialTiles()
    End   

    '
    ' TODO: Define Object Renderer
    '
    Method RenderObjects:Void()
        For Local o := EachIn objects
            Local tileId% = Int(o.properties.Get("gid"))
            If (tileId > 0)
                Local tileset := parentMap.GetTilesetForTileId(tileId)
                Local x% = Int(o.properties.Get("x"))
                Local y% = Int(o.properties.Get("y"))
                DrawImage tileset.tiles, x, y, tileId - tileset.firstGID
            End
        Next
    End

    Method RenderSpecialTiles:Void()
        For Local tile := EachIn specialTilesList  
            Local t := specialTiles.Get(tile)
            t.Render(GetOffsetX(), GetOffsetY())     
        Next
    End

    Method UpdateSpecialTiles:Void()
        For Local tile := EachIn specialTilesList       
            Local t := specialTiles.Get(tile)
            If (t)
                t.Update()
                If (t.IsDestroyed()) 
                    specialTiles.Remove(tile)
                    specialTilesList.Remove(tile)
                End
            End
        Next
    End

    Method SetOffsetFactor(horiz#, vert#)
        factorHoriz = horiz
        factorVert = vert
    End
    
    Method GetTileCount%(tileId%)
        Local count% = 0
        For Local x% = 0 To width-1
            For Local y% = 0 To height-1
                If (data[x][y] = tileId) Then count += 1
            Next
        Next        
        Return count
    End    

    Method GetTile%(posX%, posY%)
        If (posX < 0) Then posX = width - (Abs(posX))
        posX = posX Mod width
        If (posY < 0) Then posY = height - (Abs(posY))
        posY = posY Mod height
        Return data[posX][posY]
    End

    Method SetTile:Void(posX%, posY%, tileId%)
        data[posX][posY] = tileId
    End

    Method GetTileFromPixel%(posX%, posY%)
        posX /= tileWidth
        posY /= tileHeight
        Return GetTile(posX, posY)
    End

    Method ReplaceTile(t1%, t2%)
        For Local x% = 0 To width-1
            For Local y% = 0 To height-1
                If (data[x][y] = t1) Then data[x][y] = t2
            Next
        Next
    End

    Method SetOffset(x#, y#)        
        Self.x = x
        Self.y = y
        CheckBoundaries()
    End

    Method CheckBoundaries:Void()
        If Not loopMode
            Local w% = parentMap.GetWidthInPixel() - Application.GetInstance().width
            Local h% = parentMap.GetHeightInPixel() - Application.GetInstance().height
            If (x < 0) Then x = 0
            If (y < 0) Then y = 0
            If (x > w) Then x = w
            If (y > h) Then y = h
        End
    End

    Method Move(x#, y#)
        Self.x -= x
        Self.y -= y
        CheckBoundaries()
    End

    Method GetOffsetX#()
        Return Self.x * factorHoriz
    End
    
    Method GetOffsetY#()
        Return Self.y * factorVert
    End
    
    Method GetNextTileXY:Int[](tileId%,rX%,rY%)
        Local retVal:Int[2]
        For Local x% = rX To (width-1)
            For Local y% = rY To (height-1)
                If grid[x][y] = tileId
                    rX = x
                    rY = y
                    retVal[0] = rX
                    retVal[1] = rY
                    Return retVal
                End If
            Next
        Next    
        rX = -1
        rY = -1    
        retVal[0] = rX
        retVal[1] = rY
        Return retVal
    End
End
