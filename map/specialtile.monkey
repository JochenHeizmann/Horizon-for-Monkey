Import tileset
Import tiledmap
Import horizon.application
Import horizon.rect
Import layerrenderer

Interface SpecialTile
    Method Render:Void(offsetX#, offsetY#)
    Method Update:Void()
    Method IsDestroyed?()
End