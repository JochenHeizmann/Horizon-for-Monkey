Import horizon.utilinikey
Import horizon.language

Class Localization
    Global instance:Localization

    Field languages:StringMap<Language>
    Field currentLanguage:Language
    Field defaultLanguage:Language

    Function GetInstance:Localization()
        If Not Localization.instance
            Localization.instance = New Localization
        End If
        Return Localization.instance
    End Function

    Method New()
        languages = New StringMap<Language>
    End Method

    Method AddLanguage(file:String, defaultLanguage:Bool = False)
        Local l:Language = New Language
        l.Load(file)
        languages.Insert(file, l)
        If (defaultLanguage)
            SetLanguage(file)
            SetDefaultLanguage(file)
        End If
    End Method

    Method SetLanguage(file:String)
        currentLanguage = Language(languages.ValueForKey(file))
        If (Not currentLanguage) Then RuntimeError "Language " + file + " not found!"
    End Method

    Method SetDefaultLanguage(file:String)
        defaultLanguage = Language(languages.ValueForKey(file))
        If (Not defaultLanguage) Then RuntimeError "Language " + file + " not found!"
    End Method

    Method Get:UtilIniKey(section:String, key:String)
        Return currentLanguage.Get(section, key)
    End Method

    Method Validate()
        Local error:Bool = False
        For Local s:UtilIniSection = EachIn defaultLanguage.lan.sections
            For Local key:UtilIniKey = EachIn s.keys
                For Local lankey:String = EachIn languages.Keys()
                    Local l:Language = Language(languages.ValueForKey(lankey))
                    If l = defaultLanguage Then Continue
                    l.Get(s.name, key.name)
                Next
            Next
        Next
        If (error)
            Error "Language File invalid!"
        End If
    End Method
End

Function _:UtilIniKey(section:String, key:String)
    Return Localization.GetInstance().Get(section, key)
End
