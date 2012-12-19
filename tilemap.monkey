Import mojo
Import horizon.stream
Import horizon.arrayutil
Import horizon.application

Class TileMap
    Field tiles:Image
    Field grid%[][]
    Field tileWidth% = 0
    Field tileHeight% = 0
    Field mapSizeX% = 0, mapSizeY% = 0
    Field offsetX# = 0, offsetY# = 0
    Field factorHoriz# = 1, factorVert# = 1
    Field numTiles% = 0
    Field loopMode? = True

    Method LoadTileMap(file$, tileWidth%, tileHeight%)
        Local tmpImg:Image = LoadImage(file)
        numTiles = ((tmpImg.Width) / tileWidth) * ((tmpImg.Height) / tileHeight)
        tiles = LoadImage(file, tileWidth, tileHeight, numTiles)
        Self.tileWidth = tileWidth
        Self.tileHeight = tileHeight
    End
    
    Method WriteMapDataToStream(str:Stream)
        For Local x% = 0 To mapSizeX-1
            For Local y% = 0 To mapSizeX-1
                str.WriteInt(grid[x][y])
            Next
        Next
    End
    
    Method ReadMapDataFromStream(str:Stream)
        For Local x% = 0 To mapSizeX-1
            For Local y% = 0 To mapSizeX-1
                grid[x][y] = str.ReadInt()
            Next
        Next    
    End
    
    Method GetTileSize%()
        Return tileSize
    End
    
    Method SetOffsetFactor(horiz#, vert#)
        factorHoriz = horiz
        factorVert = vert
    End
    
    Method GetTileCount%(tileId%)
        Local count% = 0
        For Local x% = 0 To mapSizeX-1
            For Local y% = 0 To mapSizeX-1
                If (grid[x][y] = tileId) Then count += 1
            Next
        Next        
        Return count
    End
    
    Method SetTileMap(img:Image)
        tiles = img
        Self.tileSize = ImageWidth(tiles)
    End
    
    Method SetMapSize(sizeX%, sizeY%)
        grid = ArrayUtil2D<Int>.CreateArray(sizeX, sizeY)
        mapSizeX = sizeX
        mapSizeY = sizeY
        MapClear()
    End
    
    Method MapClear()
        For Local x% = 0 To (mapSizeX-1)
            For Local y% = 0 To (mapSizeY-1)
                grid[x][y] = -1
            Next
        Next
    End
    
    Method SetTile(posX%, posY%, tile%)
        grid[posX][posY] = tile
    End
    
    Method GetTile%(posX%, posY%)
        If (posX < 0) Then posX = mapSizeX - (Abs(posX))
        posX = posX Mod mapSizeX
        If (posY < 0) Then posY = mapSizeY - (Abs(posY))
        posY = posY Mod mapSizeY
        Return grid[posX][posY]
    End

    Method GetTileFromPixel%(posX%, posY%)
        posX /= tileWidth
        posY /= tileHeight
        Return GetTile(posX, posY)
    End
    
    Method GetMapWidthInPixel%()
        Return (mapSizeX * tileWidth)
    End
    
    Method GetMapHeightInPixel%()
        Return (mapSizeY * tileHeight)
    End
    
    Method SetOffset(x#, y#)        
        offsetX = x
        offsetY = y
        CheckBoundaries()
    End

    Method CheckBoundaries:Void()
        If Not loopMode
            Local w% = GetMapWidthInPixel() - Application.GetInstance().width
            Local h% = GetMapHeightInPixel() - Application.GetInstance().height
            If (offsetX < 0) Then offsetX = 0
            If (offsetY < 0) Then offsetY = 0
            If (offsetX > w) Then offsetX = w
            If (offsetY > h) Then offsetY = h
        End
    End

    Method Move(x#, y#)
        offsetX -= x
        offsetY -= y
        CheckBoundaries()
    End

    Method GetOffsetX#()
        Return offsetX * factorHoriz
    End
    
    Method GetOffsetY#()
        Return offsetY * factorVert
    End
    
    Method GetNextTileXY:Int[](tileId%,rX%,rY%)
        Local retVal:Int[2]
        For Local x% = rX To (mapSizeX-1)
            For Local y% = rY To (mapSizeY-1)
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
    
    Method Render()
        Local startX% = GetOffsetX() / tileWidth - 1
        Local startY% = GetOffsetY() / tileHeight - 1
        Local endX% = startX + (Application.GetInstance().width / tileWidth) + 2
        Local endY% = startY + (Application.GetInstance().height / tileHeight) + 2
        
        If Not loopMode
            If (startX < 0) Then startX = 0
            If (startY < 0) Then startY = 0
            If (endX >= mapSizeX) Then endX = mapSizeX-1
            If (endY >= mapSizeY) Then endY = mapSizeY-1
        End


        For Local x% = startX To endX
            For Local y% = startY To endY

                Local gx% = x 
                If (gx < 0) Then gx = mapSizeX - (Abs(gx) Mod mapSizeX)
                gx = gx Mod mapSizeX

                Local gy% = y
                If (gy < 0) Then gy = mapSizeY - (Abs(gy) Mod mapSizeY)
                gy = gy Mod mapSizeY

                If (grid[gx][gy] > -1)
                    Local tx% = x * tileWidth - GetOffsetX()
                    Local ty% = y * tileHeight - GetOffsetY()
                    DrawImage(tiles, tx, ty, grid[gx][gy])
                    'DrawText(grid[gx][gy], tx, ty)
                End If
            Next
        Next
    End   

    Method DrawGrid:Void()
        Local startX% = GetOffsetX() / tileWidth - 1
        Local startY% = GetOffsetY() / tileHeight - 1
        Local endX% = startX + (Application.GetInstance().width / tileWidth) + 2
        Local endY% = startY + (Application.GetInstance().height / tileHeight) + 2
        
        If Not loopMode
            If (startX < 0) Then startX = 0
            If (startY < 0) Then startY = 0
            If (endX >= mapSizeX) Then endX = mapSizeX-1
            If (endY >= mapSizeY) Then endY = mapSizeY-1
        End

        Local oldX% = startX * tileWidth - GetOffsetX()
        Local oldY% = startY * tileHeight - GetOffsetY()
        For Local x% = startX To endX
            For Local y% = startY To endY

                Local gx% = x 
                If (gx < 0) Then gx = mapSizeX - (Abs(gx) Mod mapSizeX)
                gx = gx Mod mapSizeX

                Local gy% = y
                If (gy < 0) Then gy = mapSizeY - (Abs(gy) Mod mapSizeY)
                gy = gy Mod mapSizeY

                Local tx% = x * tileWidth - GetOffsetX()
                Local ty% = y * tileHeight - GetOffsetY()
                DrawLine oldX, oldY, tx, oldY
                DrawLine oldX, ty, tx, ty
                DrawLine oldX, ty, oldX, oldY
                DrawLine tx, oldY, tx, ty
                'DrawText(grid[gx][gy], tx, ty)
            Next
        Next
    End         
End
