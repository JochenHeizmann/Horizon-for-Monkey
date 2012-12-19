Import mojo

Class Tileset
    Field firstGID%

    Field tiles:Image

    Field name$
    Field properties:StringMap<String>

    Field tileHeight%
    Field tileWidth%

    Field tileProperties:IntMap<StringMap<String>>

    Field directory$ = "map/"

    Field tilesCount%

    Method New()
        properties = New StringMap<String>
        tileProperties = New IntMap<StringMap<String>>
    End

    Method GetProperty$(tileId%, propertyName$)
        Local prop := tileProperties.Get(tileId - firstGID)
        If (prop)
            Local val := prop.Get(propertyName)
            If (val) Then Return val
        End

        Return ""
    End

    Method LoadImage:Void(imageFile$)

        If tileWidth <= 0 Then Error "Invalid Tile Width"
        If tileHeight <= 0 Then Error "Invalid Tile Height"

        Local file := directory + imageFile
        file = file.Replace("map/../", "")
        Local tmpImg:Image = mojo.graphics.LoadImage(file)
        If (Not tmpImg) Then Error "Image " + file + " not found! (" + tileWidth + "/" + tileHeight + ")"
        tilesCount = (tmpImg.Width / tileWidth) * ((tmpImg.Height) / tileHeight)
        tiles = mojo.graphics.LoadImage(file, tileWidth, tileHeight, tilesCount)
        Print "Image " + imageFile + " loaded!"
    End

    Method GetLastGID%()
        Return firstGID + tilesCount - 1
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
End   