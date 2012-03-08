import flash.net.navigateToURL;
import flash.net.URLRequest;

class util
{
	static public function NavigateToUrl(path$):void
	{
		navigateToURL(new URLRequest(path), "_self");
	}

}

