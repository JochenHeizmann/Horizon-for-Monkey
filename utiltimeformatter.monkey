Class UtilTimeFormatter
    Field time:Int
    
    Function Create:UtilTimeFormatter(time:Int)
        time/=1000
        Local t:UtilTimeFormatter = New UtilTimeFormatter
        t.time = time
        Return t
    End Function
    
    Method SetTime(t:Int)
        time = t / 1000
    End Method
    
    Method GetHours$()
        Return Format(time / 60.0 / 60.0)
    End Method
    
    Method GetMinutes$()
        Return Format((time / 60.0) Mod 60)
    End Method
    
    Method GetSeconds$()
        Return Format(time Mod 60)
    End Method

    Method Format$(number%)
        If (number < 10) Then Return "0" + String(number)
        Return String(number)
    End
End
