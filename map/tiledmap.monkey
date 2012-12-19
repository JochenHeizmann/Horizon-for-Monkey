Import maporientation
Import tileset
Import maplayer
Import json
Import mojo
Import horizon.arrayutil

Class TiledMap
    Field width%
    Field height%
    
    Field tileHeight%
    Field tileWidth%

    Field version%
    Field orientation%

    Field layers:StringMap<MapLayer>
    Field properties:StringMap<String>

    Field tilesets:StringMap<Tileset>

    Global jsonDecoderCache:StringMap<jsondecoder> = New StringMap<jsondecoder>

    Method New()
        layers = New StringMap<MapLayer>
        tilesets = New StringMap<Tileset>
        properties = New StringMap<String>
        version = 1
        orientation = MapOrientation.ORTHOGONAL
    End

    Method Load:Void(jsonFile$)
        Local jsonDecoder := jsonDecoderCache.Get(jsonFile)
        If (Not jsonDecoder)
            jsonDecoder = New jsondecoder(LoadString(jsonFile))
            jsonDecoder.parse()
            jsonDecoderCache.Set(jsonFile, jsonDecoder)
        End
    
        For Local rootValue:jsonvalue=Eachin jsonDecoder.things
            Local rootObject := jsonobject(rootValue)
            If (rootObject)
                Self.width = rootObject.getnumbervalue("width")
                Self.height = rootObject.getnumbervalue("height")
                Self.tileWidth = rootObject.getnumbervalue("tilewidth")
                Self.tileHeight = rootObject.getnumbervalue("tileheight")
                Self.version = rootObject.getnumbervalue("version")
                LoadTilesets(rootObject.getarrayvalue("tilesets"))
                LoadLayers(rootObject.getarrayvalue("layers"))
                SetOrientation(rootObject.getstringvalue("orientation"))
                LoadProperties(rootObject.getobjectvalue("properties"))
            End
        Next
    End

    Method GetProperty$(name$)
        Return properties.Get(name)
    End

    Method GetLayer:MapLayer(name$)
        Return layers.Get(name)
    End

    Method GetTileset:Tileset(name$)
        Return tilesets.Get(name)
    End

    Method SetOffset(x#, y#)
        For Local l := EachIn layers.Values()
            l.SetOffset(x, y)
        Next
    End

    Method SetOffset(layerName, x#, y#)
        Local l := GetLayer(layerName)
        If (l)
            l.SetOffset(x,y)
        End
    End


    Method Render:Void(layerName$ = "")
        If layerName = ""
            For Local l := EachIn layers.Values()

                l.Render()
            Next
        Else
            Local l := GetLayer(layerName)
            If (l)
                l.Render()
            Else
                Print "Layer " + layerName + "not found"
            End
        End
    End

    Method Update:Void(layerName$ = "")
        If layerName = ""
            For Local l := EachIn layers.Values()
                l.UpdateSpecialTiles()
            Next
        Else
            Local l := GetLayer(layerName)
            If (l)
                l.UpdateSpecialTiles()
            Else
                Print "Layer " + layerName + "not found"
            End
        End
    End

    Method GetWidthInPixel%()
        Return (width * tileWidth)
    End
    
    Method GetHeightInPixel%()
        Return (height * tileHeight)
    End

    Private

    Method LoadLayers(layers:jsonarray)
        If (layers)
            For Local layer := Eachin layers.values
                Local l := jsonobject(layer)
                If (l)
                    Local mapLayer := New MapLayer(Self)
                    mapLayer.width = l.getnumbervalue("width")
                    mapLayer.height = l.getnumbervalue("height")
                    mapLayer.opacity = l.getnumbervalue("opacity")
                    mapLayer.name = l.getstringvalue("name")
                    mapLayer.visible = Bool(l.getliteralvalue("visible"))
                    mapLayer.x = l.getnumbervalue("x")
                    mapLayer.y = l.getnumbervalue("y")

                    Select l.getstringvalue("type")
                        Case "objectgroup"
                            mapLayer.type = MapType.OBJECT_LAYER
                        Case "tilelayer"
                            mapLayer.type = MapType.TILE_LAYER
                    End

                    mapLayer.data = ArrayUtil2D<Int>.CreateArray(mapLayer.width, mapLayer.height)
                    
                    Local mapData := l.getarrayvalue("data")
                    If mapData                        
                        Local c% = 0
                        For Local val := Eachin mapData.values
                            Local numVal := jsonnumbervalue(val)
                            If (numVal)
                                Local y% = c / mapLayer.width
                                Local x% = c Mod mapLayer.width                                      
                                mapLayer.SetTile(x, y, numVal.number)
                                c += 1
                            End
                        Next
                    End

                    Local objects := l.getarrayvalue("objects")
                    If (objects)
                        For Local val := Eachin objects.values
                            Local mapobj := New MapObject
                            For Local v := Eachin jsonobject(val).pairs
                                Select v.name
                                    Case "properties"
                                        For Local p := Eachin jsonobject(v.value).pairs
                                            mapobj.properties.Set(p.name, jsonstringvalue(p.value).txt)
                                        Next
                                    Default
                                        If (jsonstringvalue(v.value))
                                            mapobj.properties.Set(v.name, jsonstringvalue(v.value).txt)
                                        Else If (jsonnumbervalue(v.value))
                                            mapobj.properties.Set(v.name, String(jsonnumbervalue(v.value).number))
                                        End
                                End
                            Next
                            Local gidString$ = mapobj.properties.Get("gid")
                            Local gid = 0
                            If (gidString <> "") Then gid = Int(gidString)
                            If (gid > 0)
                                mapobj.properties.Set("y", Int(mapobj.properties.Get("y")) - GetTilesetForTileId(gid).tileHeight)
                            End
                            mapLayer.objects.AddLast(mapobj)
                        Next
                    End

                    Local layerProperties := l.getobjectvalue("properties")
                    If (layerProperties)
                        For Local mp := Eachin layerProperties.pairs
                            mapLayer.properties.Set(mp.name, jsonstringvalue(mp.value).txt)
                        Next
                    End

                    Self.layers.Set(mapLayer.name, mapLayer)
                End
            Next
        End
    End

    Method GetTilesetForTileId:Tileset(tileId%)
        For Local t := EachIn tilesets.Values()
            If tileId >= t.firstGID And tileId <= (t.GetLastGID()) Then Return t
        Next
        Error "Tile " + tileId + " not found in tilesets!"
    End

    Method SetOrientation:Void(orientation$)
        Select orientation
            Case "orthogonal"
                Self.orientation = MapOrientation.ORTHOGONAL
            Case "isometric"
                Self.orientation = MapOrientation.ISOMETRIC
        End
    End

    Method LoadProperties:Void(mapProperties:jsonobject)
        For Local mp := Eachin mapProperties.pairs
            Self.properties.Set(mp.name, jsonstringvalue(mp.value).txt)
        Next
    End

    Method LoadTilesets:Void(tilesets:jsonarray)
        If (tilesets)
            For Local tileset := Eachin tilesets.values
                Local t := jsonobject(tileset)
                If (t)
                    Local tset := New Tileset
                    tset.firstGID = t.getnumbervalue("firstgid")
                    tset.name = t.getstringvalue("name")
                    tset.tileWidth = t.getnumbervalue("tilewidth")
                    tset.tileHeight = t.getnumbervalue("tileheight")
                    tset.LoadImage(t.getstringvalue("image"))

                    Local props := t.getobjectvalue("properties")
                    For Local p := Eachin props.pairs
                        tset.properties.Set(p.name, jsonstringvalue(p.value).txt)
                    Next

                    props = t.getobjectvalue("tileproperties")
                    If (props)
                        For Local p := Eachin props.pairs
                            Local tileProps := New StringMap<String>

                            If (jsonobject(p.value))
                                For Local tp := Eachin jsonobject(p.value).pairs
                                    tileProps.Set(tp.name, jsonstringvalue(tp.value).txt)
                                Next
                            End

                            tset.tileProperties.Set(Int(p.name), tileProps)
                        Next
                    End
                    Self.tilesets.Set(tset.name, tset)
                End
            Next
        End
    End
End