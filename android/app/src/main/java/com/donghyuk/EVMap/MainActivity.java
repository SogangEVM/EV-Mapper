package com.donghyuk.EVMap;

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

    private static final String CHANNEL = "electric_vehicle_mapper/tmapInvoke";

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
                            String destination = call.argument("destination");
                            float lat = Float.parseFloat(call.argument("lat"));
                            float lng = Float.parseFloat(call.argument("lng"));
                            boolean installed = invokeTmap(destination, lat, lng);
                            result.success(installed);
                        } 
                    }
                });
    }

    private boolean invokeTmap(String destination,float lat, float lng) {
        TMapTapi tmaptapi = new TMapTapi(this);
        tmaptapi.setSKTMapAuthentication ("l7xxb841ff64eae6428a8b2ee688cd8abb94");
        boolean installed = tmaptapi.isTmapApplicationInstalled();
        if(!installed) {
            return false;
        }
        else {
            tmaptapi.invokeRoute(destination, lng, lat);
            return true;
        }
    }

}
