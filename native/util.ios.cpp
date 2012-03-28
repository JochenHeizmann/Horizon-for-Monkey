
class util {
public:
	static UIAlertView *openURLAlert;

	void static NavigateToUrl(String url) {
		NSString *stringUrl = url.ToNSString();
		NSURL *nsUrl = [NSURL URLWithString$Url];
		[[UIApplication sharedApplication] openURL:nsUrl];
	}

	int static GetTimestamp() {
		time_t unixTime = (time_t) [[NSDate date] timeIntervalSince1970];
		return static_cast<int>(unixTime);

	}

	void static Alert(String title, String message, String buttoncaption)
	{
		NSString *NSstrTitle = title.ToNSString();
		NSString *NSStrMessage = message.ToNSString();
		NSString * NSStrButtonCaption = buttoncaption.ToNSString();

		UIAlertView *openURLAlert = [[UIAlertView alloc] initWithTitle:NSstrTitle message:NSStrMessage delegate:nil cancelButtonTitle:NSStrButtonCaption otherButtonTitles:nil];
		[openURLAlert showModal];
		[openURLAlert release];
	}

};
