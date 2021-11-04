package com.donghyuk.EVMap;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import android.os.Bundle;

import io.flutter.plugins.GeneratedPluginRegistrant;

import com.kakao.sdk.common.KakaoSdk;
import com.kakao.sdk.navi.NaviClient;
import com.kakao.sdk.navi.model.Location;
import com.kakao.sdk.navi.model.CoordType;
import com.kakao.sdk.navi.model.NaviOption;
import com.skt.Tmap.TMapTapi;

import io.flutter.embedding.engine.FlutterEngine;

public class MainActivity extends FlutterActivity {

    private static final String TMAPCHANNEL = "electric_vehicle_mapper/tmapChannel";
    private static final String KAKAONAVICHANNEL = "electric_vehicle_mapper/kakaonaviChannel";
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        
        super.onCreate(savedInstanceState);
        FlutterEngine flutterEngine = new FlutterEngine(this);
        GeneratedPluginRegistrant.registerWith(flutterEngine);
        KakaoSdk.init(this, "4b9a4abdfc5d02f9b075402afb3d754e");


        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), TMAPCHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {

                        if(call.method.equals("invokeTmap")) {
                            String destination = call.argument("destination");
                            float lat = Float.parseFloat(call.argument("lat"));
                            float lng = Float.parseFloat(call.argument("lng"));
                            boolean installed = invokeTmap(destination, lat, lng);
                            result.success(installed);
                        } 
                    }
                });

        new MethodChannel(getFlutterEngine().getDartExecutor().getBinaryMessenger(), KAKAONAVICHANNEL).setMethodCallHandler(
                new MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall call, Result result) {

                        if(call.method.equals("invokeKakaonavi")) {
                            String destination = call.argument("destination");
                            String startLat = call.argument("startLat");
                            String startLng = call.argument("startLng");
                            String destLat = call.argument("destLat");
                            String destLng = call.argument("destLng");
                            boolean installed = invokeKakaonavi(destination, destLat, destLng);
                            result.success(installed);
                        }
                    }
                });
    }

    private boolean invokeTmap(String destination, float lat, float lng) {
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

    private boolean invokeKakaonavi(String destination, String destLat, String destLng) {
        if(NaviClient.getInstance().isKakaoNaviInstalled(this)) {} else {
            return false;
        }
        Location location = new Location(destination, destLng, destLat);
        NaviOption option = new NaviOption(CoordType.WGS84);
        startActivity(
                NaviClient.getInstance().shareDestinationIntent(
                        location,
                        option
                )
        );
        return true;
    }

}
