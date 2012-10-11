import flash.net.navigateToURL;
import flash.net.URLRequest;

class util
{
    static public function NavigateToUrl(path:String):void
    {
        navigateToURL(new URLRequest(path), "_blank");
    }

    static public function IsTabletDevice():Boolean
    {
        return false;
    }
}