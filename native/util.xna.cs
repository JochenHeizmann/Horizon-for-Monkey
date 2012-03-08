public class util {
	public static void NavigateToUrl(String path) {
		#if WINDOWS
			System.Diagnostics.Process.Start("IExplore.exe", path);
		#endif
	}

	public static int GetTimestamp() {
		return (int) (DateTime.Now.Ticks) / 10000;
	}
}
