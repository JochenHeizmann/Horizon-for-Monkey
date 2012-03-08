import android.net.Uri;

class util {
	static void NavigateToUrl(String url) {
		Intent i = new Intent(Intent.ACTION_VIEW);
		i.setData(Uri.parse(url));
		MonkeyGame.activity.startActivity(i);
	}
	
	static int GetTimestamp() {
		return 0;
	}
}