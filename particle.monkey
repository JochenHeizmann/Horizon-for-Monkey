Import mojo

Const MAX_EMITTER_SLOTS% = 10
Const TPARTICLE_VER$ = "1.1"

Class Particle
    Global ParticleSprites:Image 

    Function SetImage(img:Image)
        Particle.ParticleSprites = img
        Particle.ParticleSprites.SetHandle(Particle.ParticleSprites.Width / 2, Particle.ParticleSprites. Height / 2)
    End

    Field x#
    Field y#
    Field zoom#
    Field alpha#
    
    Field gravityX#, gravityY#
    
    Field dx#
    Field dy#
    
    Field r#, g#, b#
    
    Field rotation#
    Field rotation_speed#
    
    Field frame%
    
    Method New()
        zoom = 1.0
        frame = 0
    End
    
    Function Create:Particle(x#, y#, zoom# = 1, dx# = 0, dy# = 0, alpha# = 1.0, r# = 255, g# = 255, b# = 255, rotation_speed# = 0, gravityX# = 0, gravityY# = 0, rotation# = 0)
        'ToDo: Object Pooling
        Local par:Particle = New Particle
        par.x = x
        par.y = y
        par.zoom = zoom
        par.dx = dx
        par.dy = dy
        par.alpha = alpha
        par.r = r
        par.g = g
        par.b = b
        par.rotation_speed = rotation_speed
        par.rotation = rotation
        par.gravityX = gravityX
        par.gravityY = gravityY
        Return par        
    End
End