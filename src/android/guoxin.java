package cordova.plugin.guoxin;

import android.app.Activity;
import android.util.Log;

import com.photograph.PhotoSDkApi;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Map;

/**
 * This class echoes a string called from JavaScript.
 */
public class guoxin extends CordovaPlugin {
    String TAG = getClass().getSimpleName();

    @Override
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if (action.equals("startTakePhoto")) {
            JSONObject message = args.getJSONObject(0);
            this.startTakePhoto(message, callbackContext);
            return true;
        }
        return false;
    }

    /**
     * 调取国信
     * @param param
     * @param callbackContext
     */
    private void startTakePhoto(JSONObject param, final CallbackContext callbackContext) {
        if (param != null && param.length() > 0) {
            PhotoSDkApi api = PhotoSDkApi.init(this.cordova.getActivity());
            try {
                JSONObject  starttakePhotoParame=param;
                api.startTakePhoto(starttakePhotoParame, new com.photograph.ui.StartSDKCallBack() {
                    @Override
                    public void startResult(String s) {
                        Log.e(TAG, "barcode" + ":" + s);
                        callbackContext.success(s);
                    }
                });
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            callbackContext.error("Expected one non-empty string argument.");
        }
    }

    private void test(String param) {
        String barcode = "";
        PhotoSDkApi api = PhotoSDkApi.init(this.cordova.getActivity());
        JSONObject starttakePhotoParame = null;
        try {
            starttakePhotoParame = new JSONObject(param);
            api.startTakePhoto(starttakePhotoParame, new com.photograph.ui.StartSDKCallBack() {
                @Override
                public void startResult(String s) {
                    //barcode
                    Log.e("barcode", s + ":" + s);
                }
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }
        try {
            starttakePhotoParame.put("serverurl", "http://58.250.250.28:8081/SiitApp/appserver/allService");
            starttakePhotoParame.put("guestcode", "YBZApp");
            // String userPhone = (String) appContext.vars.get("phone");
            starttakePhotoParame.put("username", "13641081611");
            String datetime = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
            starttakePhotoParame.put("datetime", datetime);
            starttakePhotoParame.put("servername", "startSiitApp");
            starttakePhotoParame.put("customcode", "efgf8xd9");
            JSONObject params = new JSONObject();
            params.put("token", "");
            params.put("barcode", barcode == null ? "" : barcode);
            params.put("fordername", "上传附件");
            starttakePhotoParame.put("param", params);
            starttakePhotoParame.put("ticket", "8B58FCFE4E3339EDCBF131CE095571D9");
        } catch (Exception e) {
        }
        api.startTakePhoto(starttakePhotoParame, new com.photograph.ui.StartSDKCallBack() {
            @Override
            public void startResult(String s) {
                Log.e("界面打开", s + ":" + s);
            }
        });
    }
}
