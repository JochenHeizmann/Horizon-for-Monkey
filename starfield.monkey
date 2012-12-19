Import mojo
Import horizon.application

Class StarField
    Field numStars%
    Field maxDepth%
    Field stars#[]

    Field starX#[]
    Field starY#[]

    Field starSpeed#

    Method New()
        numStars = 512
        maxDepth = 32
        starSpeed = 0.19
        InitStars()
    End

    Method New(numStars%, maxDepth%, starSpeed# = 0.19)
        Self.numStars = numStars
        Self.maxDepth = maxDepth
        Self.starSpeed = starSpeed
        InitStars()
    End

    Method InitStars:Void()
        stars = stars.Resize(numStars * 3)
        starX = starX.Resize(numStars)
        starY = starX.Resize(numStars)
        For Local i := 0 To stars.Length()-1 Step 3
            stars[i] = Rnd(-25, 25)
            stars[i+1] = Rnd(-25, 25)
            stars[i+2] = Rnd(1, maxDepth)
        Next
    End

    Method Update:Void()
        Local ox := Application.GetInstance().width / 2
        Local oy := Application.GetInstance().height / 2

        For Local i := 0 To stars.Length()-1 Step 3
            stars[i+2] = stars[i+2] - starSpeed

            If stars[i+2] <= 0
                stars[i] = Rnd(-25, 25)
                stars[i+1] = Rnd(-25, 25)
                stars[i+2] = maxDepth
            End

            Local k := 128.0 / stars[i+2]
            starX[i/3] = stars[i] * k + ox
            starY[i/3] = stars[i+1] * k + oy
        Next
    End

    Method Render:Void()
        For Local i := 0 To starX.Length()-1
            Local size := (1 - Float(stars[i*3+2]) / maxDepth) * 2
            Local shade := Clamp((1 - Float(stars[i*3+2]) / maxDepth), 0.0, 1.0)
            SetAlpha(shade)
            DrawCircle(starX[i] - size/2, starY[i]- size/2, size)
        Next
        SetAlpha(1)
        SetColor(255,255,255)
    End
End