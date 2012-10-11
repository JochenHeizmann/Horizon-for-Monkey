Import horizon.particleemitter
Import horizon.stream

Class ParticleFX
    Field Emitter:ParticleEmitter[10]
    Field LoopFX?
    Field Running?
    
    Method New()
        For Local i:Int = 0 To 9
            Emitter[i] = New ParticleEmitter
        Next        
        
        LoopFX = False
        Running = True
    End
        
    Function DuplicateFrom:ParticleFX(pfx:ParticleFX)
        Local n:ParticleFX = New ParticleFX
        n.LoopFX = pfx.LoopFX
        n.Running = pfx.Running
        For Local i:Int = 0 To 9
            n.Emitter[i].X = pfx.Emitter[i].X
            n.Emitter[i].Y = pfx.Emitter[i].Y
            n.Emitter[i].EmitterDelay = pfx.Emitter[i].EmitterDelay 
            n.Emitter[i].EmitterDuration = pfx.Emitter[i].EmitterDuration 
            n.Emitter[i].EmissionRate = pfx.Emitter[i].EmissionRate 
            n.Emitter[i].EmissionEachFrame = pfx.Emitter[i].EmissionEachFrame 
            n.Emitter[i].Image = pfx.Emitter[i].Image 
            n.Emitter[i].SpeedX = pfx.Emitter[i].SpeedX 
            n.Emitter[i].SpeedY = pfx.Emitter[i].SpeedY 
            n.Emitter[i].SpeedVarX = pfx.Emitter[i].SpeedVarX 
            n.Emitter[i].SpeedVarY = pfx.Emitter[i].SpeedVarY 
            n.Emitter[i].LaunchSize = pfx.Emitter[i].LaunchSize 
            n.Emitter[i].SizeVar = pfx.Emitter[i].SizeVar 
            n.Emitter[i].Grow = pfx.Emitter[i].Grow 
            n.Emitter[i].MinSize = pfx.Emitter[i].MinSize 
            n.Emitter[i].MaxSize = pfx.Emitter[i].MaxSize 
            n.Emitter[i].Alpha = pfx.Emitter[i].Alpha 
            n.Emitter[i].AlphaVar = pfx.Emitter[i].AlphaVar 
            n.Emitter[i].AlphaChange = pfx.Emitter[i].AlphaChange 
            n.Emitter[i].RotationSpeed = pfx.Emitter[i].RotationSpeed 
            n.Emitter[i].RotationVar = pfx.Emitter[i].RotationVar 
            n.Emitter[i].RotationStart = pfx.Emitter[i].RotationStart 
            n.Emitter[i].ColorR = pfx.Emitter[i].ColorR 
            n.Emitter[i].ColorG = pfx.Emitter[i].ColorG 
            n.Emitter[i].ColorB = pfx.Emitter[i].ColorB 
            n.Emitter[i].ColorChangeR = pfx.Emitter[i].ColorChangeR 
            n.Emitter[i].ColorChangeG = pfx.Emitter[i].ColorChangeG 
            n.Emitter[i].ColorChangeB = pfx.Emitter[i].ColorChangeB 
            n.Emitter[i].StartOffsetX = pfx.Emitter[i].StartOffsetX 
            n.Emitter[i].StartOffsetY = pfx.Emitter[i].StartOffsetY 
            n.Emitter[i].StartOffsetVarX = pfx.Emitter[i].StartOffsetVarX 
            n.Emitter[i].StartOffsetVarY = pfx.Emitter[i].StartOffsetVarY 
            n.Emitter[i].GravityX = pfx.Emitter[i].GravityX 
            n.Emitter[i].GravityY = pfx.Emitter[i].GravityY 
            n.Emitter[i].LifeTime = pfx.Emitter[i].LifeTime 
            n.Emitter[i].RenderType = pfx.Emitter[i].RenderType 
        Next
        Return n        
    End
    
    Method SetLoop(t?)
        LoopFX = t
    End
    
    Method MoveTo(x#, y#)
        For Local i:Int = 0 To 9
            Emitter[i].x = x
            Emitter[i].y = y
        Next
    End
        
    Method Render(delta# = 1.0, LaunchNewParticles?=True)
        Local a# = GetAlpha()
        Local sx#, sy#
    
        If Running
            For Local i:Int = 0 To 9
                Emitter[i].Render(delta,LaunchNewParticles)
                If LoopFX
                    Emitter[i].Loop()
                End     
            Next    
        End
        
        SetAlpha(a)
        SetColor(255,255,255)
    End
    
    Method Finished?()
        Local count:Int = 0
        For Local i:Int = 0 To 9
            If Emitter[i].Finished() Or Emitter[i].RenderType = ParticleEmitter.RENDER_OFF Then count+=1
        Next
        If count>9 Then Return True Else Return False
    End
    
    Function Load:ParticleFX(Filename:String, Loop? = False)
        Local t:ParticleFX = New ParticleFX
        t.LoadFX(Filename)
        t.LoopFX = Loop
        Return t        
    End
    
    Method Stop()
        Running = False
    End
    
    Method Restart()
        For Local i:Int = 0 To 9
            Emitter[i].frame = 0
        Next
        Running = True
    End
    
    Method Reset()
        For Local i:Int = 0 To 9
            Emitter[i].Reset()    
        Next
    End
    
    Method LoadFX (Filename:String)
        Local f:Stream = New Stream(Filename)
        If (f)
            For Local i:Int = 0 To 9
                Emitter[i].EmitterDelay = f.ReadFloat()
                Emitter[i].EmitterDuration = f.ReadFloat()
                Emitter[i].EmissionRate = f.ReadFloat()
                Emitter[i].EmissionEachFrame = f.ReadFloat()
                Emitter[i].SpeedX = f.ReadFloat()
                Emitter[i].SpeedY = f.ReadFloat()
                Emitter[i].SpeedVarX = f.ReadFloat()
                Emitter[i].SpeedVarY = f.ReadFloat()
                Emitter[i].SizeVar = f.ReadFloat()
                Emitter[i].LaunchSize = f.ReadFloat()
                Emitter[i].Grow = f.ReadFloat()
                Emitter[i].MinSize     = f.ReadFloat()
                Emitter[i].MaxSize = f.ReadFloat()
                Emitter[i].Alpha = f.ReadFloat()
                Emitter[i].AlphaVar = f.ReadFloat()
                Emitter[i].AlphaChange = f.ReadFloat()
                Emitter[i].RotationSpeed  = f.ReadFloat()
                Emitter[i].RotationVar      = f.ReadFloat()
                Emitter[i].RotationStart      = f.ReadFloat()
                Emitter[i].StartOffsetX      = f.ReadFloat()
                Emitter[i].StartOffsetY  = f.ReadFloat()
                Emitter[i].StartOffsetVarX     = f.ReadFloat()
                Emitter[i].StartOffsetVarY = f.ReadFloat()
                Emitter[i].ColorChangeR     = f.ReadFloat()
                Emitter[i].ColorChangeG     = f.ReadFloat()
                Emitter[i].ColorChangeB = f.ReadFloat()
                Emitter[i].LifeTime     = f.ReadFloat()
                Emitter[i].RenderType = f.ReadInt()
                Emitter[i].Image     = f.ReadInt()
                Emitter[i].ColorR     = f.ReadFloat()
                Emitter[i].ColorG     = f.ReadFloat()
                Emitter[i].ColorB = f.ReadFloat()
                Emitter[i].gravityX = f.ReadFloat()
                Emitter[i].gravityY = f.ReadFloat()
            Next
            f.Close()
        Else
            Error "Could not load Particle FX"
        End If
    End    
End