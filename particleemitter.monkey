
Import horizon.particle

Class ParticleEmitter
    Const RENDER_ALPHA% = 0
    Const RENDER_ADD% = 1
    Const RENDER_MUL% = 2
    Const RENDER_OFF% = 3

    Global scaleFactor# = 1.0
    Global mapOffsetX# = 1.0
    Global mapOffsetY# = 1.0
    
    Field frame% = 0

    Field Particles:List<Particle>
    
    Field x#, y#
    
    Field EmitterDelay#    'Delay before Particles will be launched
    Field EmitterDuration# 'Duration how long Particles will be launched
    Field EmissionRate#    'How many Particles are launched in one second
    Field EmissionEachFrame#

    Field Image%                'ParticleSprite / Frame
    
    Field SpeedX#            'X-Speed
    Field SpeedY#            'Y-Speed
    Field SpeedVarX#        'Random-Variation of X-Speed
    Field SpeedVarY#        'Random-Variaiont of Y-Speed
    
    Field LaunchSize#        '1.0 = Original Size
    Field SizeVar#            'Variation of Size
    Field Grow#            'Growing of Particle
    Field MinSize#            'Min Size of a growing particle
    Field MaxSize#            'Max Size of a growing particle
    
    Field Alpha#
    Field AlphaVar#
    Field AlphaChange#
    
    Field RotationSpeed#
    Field RotationVar#
    Field RotationStart#    
    
    Field ColorR#
    Field ColorG#
    Field ColorB#
    
    Field ColorChangeR#
    Field ColorChangeG#
    Field ColorChangeB#
    
    Field StartOffsetX#    'in Pixel
    Field StartOffsetY#
    Field StartOffsetVarX#
    Field StartOffsetVarY#
    
    Field gravityX#, gravityY#
    
    Field LifeTime#
    
    Field RenderType%
    
    Field StartTime#, CurrTime#    

    Method Reset()
        For Local par:TParticle = EachIn Particles
            ListRemove(Particles, par) ; par = Null
        Next        
    End
    
    Method New()
        Particles = New List<Particle>
        
        EmissionEachFrame = 1.0
        
        x = 220
        y = 330
        
        EmitterDelay         = 0
        EmitterDuration     = 10
        EmissionRate        = 1
        
        Image                = 4
        SpeedX                = 0
        SpeedY                = 0
        SpeedVarX            = 0
        SpeedVarY            = 0
        LaunchSize         = 1
        SizeVar                = 0
        Grow                = 0.000
        MaxSize                = 1
        
        Alpha                = 1
        AlphaVar            = 0
        AlphaChange        = 0
        RotationSpeed        = 0
        RotationVar        = 0
        ColorR                = 255
        ColorG                = 255
        ColorB                = 255
        ColorChangeR        = 0
        ColorChangeG        = 0
        ColorChangeB        = 0
        
        StartOffsetX        = 0
        StartOffsetY        = 0
        StartOffsetVarX    = 0
        StartOffsetVarY    = 0
        
        gravityX = 0
        gravityY = 0
        
        LifeTime            = 100
        
        RotationStart         = 0
        
        RenderType            = RENDER_OFF        
    End
    
    Function SetGlobalOffset(offX:Double, offY:Double, factor#)
        scaleFactor = factor
        mapOffsetX = offX
        mapOffsetY = offY
    End

    Method Loop()
        If (frame>EmitterDuration+EmitterDelay) Then frame=0
    End
    
    Method Finished?()
        If (frame>(EmitterDuration+EmitterDelay+Lifetime)) Then Return True Else Return False
    End
    
    Method Render(delta# = 1.0, LaunchNewParticles? = True)        
        If RenderType = RENDER_OFF Then Return
    
        Local a# = GetAlpha()
        Local blend := GetBlend()
            
        If frame=0 Then StartTime=Millisecs()
        CurrTime = Millisecs()-StartTime
        frame += 1

        'Update    
        If LaunchNewParticles And (frame Mod EmissionEachFrame = 0)
            If frame<=(EmitterDuration+EmitterDelay) And frame>=EmitterDelay
                For Local i% = 0 To EmissionRate
                    Particles.AddLast(Particle.Create(x + StartOffsetX + Rnd(-StartOffsetVarX,StartOffsetVarX), y + StartOffsetY + Rnd(-StartOffsetVarY, StartOffsetVarY),LaunchSize + Rnd(-SizeVar,SizeVar), SpeedX + Rnd(-SpeedVarX,SpeedVarX), SpeedY + Rnd(-SpeedVarY, SpeedVarY),Alpha + Rnd(-AlphaVar,AlphaVar),ColorR, ColorG, ColorB,RotationSpeed+Rnd(-RotationVar,RotationVar),gravityX, gravityY, RotationStart))
                Next
            End
        End
        
        
        Select RenderType
            Case RENDER_ALPHA
                SetBlend AlphaBlend
            Case RENDER_ADD
                SetBlend AdditiveBlend
            Case RENDER_MUL
                'SetBlend SHADEBLEND
        End
          
        For Local par:Particle = EachIn Particles       
            If par.zoom < MinSize Then par.zoom = MinSize
            If par.zoom > MaxSize Then par.zoom = MaxSize
            
            par.x += (par.dx*delta)
            par.y += (par.dy*delta)
            
            par.dx += (gravityX*delta)
            par.dy += (gravityY*delta)
            
            SetAlpha(par.alpha)
            SetColor(par.r, par.g, par.b)
            
            DrawImage Particle.ParticleSprites,(par.x + mapOffsetX) * scaleFactor, (par.y + mapOffsetY) * scaleFactor,par.rotation,par.zoom * scaleFactor, par.zoom * scaleFactor, Image
        
            par.r += (ColorChangeR*delta)
            par.g += (ColorChangeG*delta)
            par.b += (ColorChangeB*delta)
            
            par.alpha += (AlphaChange*delta)
            par.rotation += (par.rotation_speed*delta)
            
            par.zoom += (Grow*delta)
        
            ' Check Lifespan
            par.frame += 1
            If par.frame>LifeTime Then Particles.Remove(par) ; par = Null
        Next

        SetAlpha(a)
        SetColor(255,255,255)
        SetBlend(blend)
    End 
End

