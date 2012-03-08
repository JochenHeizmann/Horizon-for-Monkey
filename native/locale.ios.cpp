
class Locale : public gxtkObject
{
public:
	static String GetDefaultLanguage()
	{
		NSString * language = [[NSLocale preferredLanguages] objectAtIndex:0];
		return String(language);
	}
};

