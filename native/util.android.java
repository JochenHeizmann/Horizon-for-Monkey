import android.net.Uri;
import java.io.*;

class util {
	static void NavigateToUrl(String url) {
		Intent i = new Intent(Intent.ACTION_VIEW);
		i.setData(Uri.parse(url));
		MonkeyGame.activity.startActivity(i);
	}
	
	static int GetTimestamp() {
		return 0;
	}
	static boolean IsTabletDevice() {
		return false;
	}

    static void SaveInternalFile(String fileName, String data)
    {
        try {
            FileOutputStream fos = MonkeyGame.activity.openFileOutput(fileName, Context.MODE_PRIVATE);
            fos.write(data.getBytes());
            fos.close();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch(IOException e){
            e.printStackTrace();
        }
    }

    static String LoadInternalFile(String fileName)
    {
        try {
            FileInputStream fin = MonkeyGame.activity.openFileInput(fileName);
            StringBuffer fileContent = new StringBuffer("");

            byte[] buffer = new byte[1024];
            int length;
            
            while ((length = fin.read(buffer)) != -1) {
                fileContent.append(new String(buffer));      
            }

            return fileContent.toString();
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        } catch(IOException e){
            e.printStackTrace();
        }

        return "";
    }
}