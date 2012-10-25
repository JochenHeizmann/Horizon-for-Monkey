Import horizon.utilinireader
Import horizon.utilinikey

Class Language
    Field lan:UtilIniReader

    Method Get:UtilIniKey(section:String, key:String)
        Return lan.GetKey(section, key)
    End Method

    Method Load(file:String)
        lan = UtilIniReader.Load(file)
    End Method
End
