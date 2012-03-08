#if TARGET="ios"
	Import "native/locale.ios.cpp"

	Extern
		Class Locale="Locale"
			Function GetDefaultLanguage$()="Locale::GetDefaultLanguage"
		End
	Public
#else
	' TODO: Implement for other platforms
	Class Locale
		Function GetDefaultLanguage$()
			Return "en"
		End
	End
#end