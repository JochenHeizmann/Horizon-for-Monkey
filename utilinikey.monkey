Class UtilIniKey
    Field name  : String
    Field value : String

    Field parameters:StringMap<String>

    Method New()
        parameters = New StringMap<String>
    End Method

    Method Assign:UtilIniKey(key:String, value:String)
        parameters.Insert(key, value)
        Return Self
    End Method

    Method str:String()
        Local v:String = value
        For Local key:String = EachIn parameters.Keys()
            v = v.Replace("{" + key + "}", String(parameters.ValueForKey(key)))
        Next
        Return v
    End Method
End
