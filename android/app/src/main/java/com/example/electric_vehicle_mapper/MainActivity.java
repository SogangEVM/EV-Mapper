package com.example.electric_vehicle_mapper;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.os.Bundle;
import io.flutter.plugins.GeneratedPluginRegistrant;
import com.skt.Tmap.TMapTapi;

import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {

    private static final String CHANNEL = "samples.flutter.dev/tmapInvoke";


    @Override
    public void onCreate(Bundle savedInstanceState) {
        
        super.onCreate(savedInstanceState);
        FlutterEngine flutterEngine = new FlutterEngine(this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), CHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {

                        if(call.method.equals("tmapInvoke")) {
                            float lat = call.argument("lat");
                            float lng = call.argument("lng");
                            invokeTmap(lat, lng);
                        } 
                    }
                });
    }

    private void invokeTmap(float lat, float lng) {
        TMapTapi tmaptapi = new TMapTapi(this);
        tmaptapi.setSKTMapAuthentication ("l7xxb841ff64eae6428a8b2ee688cd8abb94");
        tmaptapi.invokeRoute("타월", lat, lng);
    }

}
