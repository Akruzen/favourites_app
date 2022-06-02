package com.example.favourites_app;

import android.content.ClipData;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.hbisoft.pickit.PickiT;
import com.hbisoft.pickit.PickiTCallbacks;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MainActivity extends FlutterActivity implements PickiTCallbacks {

    private Map<String, String> sharedData = new HashMap();
    String pathFinal;
    String sharedText;
    private static final String CHANNEL = "channel";
    PickiT pickiT;

    void handleSendText(Intent intent) {
        String sharedText = intent.getStringExtra(Intent.EXTRA_TEXT);
    }
    void handleSendFile(Intent intent) {
        System.out.println("Get data get path to String: " + intent.getData().getPath());
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        System.out.println("Inside onCreate");

        // Get intent, action and MIME type
        Intent intent = getIntent();
        String action = intent.getAction();
        String type = intent.getType();
        pickiT = new PickiT(this, this, this);

        if (Intent.ACTION_SEND.equals(action) && type != null) {
            if ("text/plain".equals(type)) {
                handleSendText(intent); // Handle text being sent
            } else {
                System.out.println("Received file intent");
                ClipData clipData = Objects.requireNonNull(intent).getClipData();
                if (clipData != null) {
                    System.out.println("Clip data is not null");
                    pickiT.getPath(clipData.getItemAt(0).getUri(), Build.VERSION.SDK_INT);
                }
                // handleSendFile(intent); // Handle single image being sent
            }
        }

        /*handleSendIntent(getIntent());*/

        new MethodChannel(getFlutterEngine().getDartExecutor(), CHANNEL).setMethodCallHandler(new MethodChannel.MethodCallHandler() {
            @Override
            public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
                if (call.method.equals("getSharedData")) {
                    System.out.println("Jave printing: " + pathFinal);
                    result.success(pathFinal);
                }
            }
        });

        /*new MethodChannel(Objects.requireNonNull(getFlutterEngine()).getDartExecutor().getBinaryMessenger(), "channel").setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, MethodChannel.Result result) {
                        System.out.println("Inside onMethodCall");
                        if (call.method.contentEquals("getSharedData")) {
                            System.out.println("Jave printing: " + fileUri);
                            result.success(sharedData);
                            sharedData.clear();
                        }
                    }
                }
        );*/
    }

    @Override
    public void PickiTonUriReturned() {
        System.out.println("Inside onURI returned");
    }

    @Override
    public void PickiTonStartListener() {
        System.out.println("Inside start listener");
    }

    @Override
    public void PickiTonProgressUpdate(int progress) {
        System.out.println("Inside progress update");
    }

    @Override
    public void PickiTonCompleteListener(String path, boolean wasDriveFile, boolean wasUnknownProvider, boolean wasSuccessful, String Reason) {
        System.out.println("Inside on complete listener");
        if (wasSuccessful) {
            System.out.println("Was successful and path is: " + path);
            pathFinal = path;
        }
    }

    @Override
    public void PickiTonMultipleCompleteListener(ArrayList<String> paths, boolean wasSuccessful, String Reason) {

    }

    /*@Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);

    }

    @Override
    protected void onNewIntent(@NonNull Intent intent) {
        super.onNewIntent(intent);
        System.out.println("Inside onNewIntent");
        handleSendIntent(intent);
    }

    private void handleSendIntent(Intent intent) {
        System.out.println("Inside handleSendIntent");
        String action = intent.getAction();
        String type = intent.getType();

        // We only care about sharing intent that contain plain text
        if (Intent.ACTION_SEND.equals(action) && type != null) {
            System.out.println("Inside intent if");
            if ("text/plain".equals(type)) {
                System.out.println("Intent is plaint text");
                sharedData.put("subject", intent.getStringExtra(Intent.EXTRA_SUBJECT));
                sharedData.put("text", intent.getStringExtra(Intent.EXTRA_TEXT));
            }
        }
    }*/
}
