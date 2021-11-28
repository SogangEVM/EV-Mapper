import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:electric_vehicle_mapper/src/screens/evm_map/main_map.dart';
import 'package:electric_vehicle_mapper/src/components/dialogs.dart';

const _tmapChannel = const MethodChannel("electric_vehicle_mapper/tmapChannel");
const _kakaoNaviChannel =
    const MethodChannel("electric_vehicle_mapper/kakaonaviChannel");

// Function for invoke kakaonavi application
Future<void> invokeKakaonavi(BuildContext context, String destination,
    double destLat, double destLng) async {
  try {
    var result = await _kakaoNaviChannel.invokeMethod("invokeKakaonavi", {
      "destination": destination,
      "startLat": "${currentLat}",
      "startLng": "${currentLng}",
      "destLat": "${destLat}",
      "destLng": "${destLng}"
    });
    showNotInstalledDialog(context, result, "카카오내비가 설치되어 있지 않습니다.",
        "카카오내비를 설치하시겠습니까?", "com.locnall.KimGiSa", "417698849");
  } on PlatformException catch (e) {
    print(e.message);
  }
}

// Function for invoke TMAP application
Future<void> invokeTmap(BuildContext context, String destination,
    double destLat, double destLng) async {
  try {
    var result = await _tmapChannel.invokeMethod("invokeTmap",
        {"destination": destination, "lat": "${destLat}", "lng": "${destLng}"});
    showNotInstalledDialog(context, result, "TMAP이 설치되어 있지 않습니다.",
        "TMAP을 설치하시겠습니까?", "com.skt.tmap.ku", "431589174");
  } on PlatformException catch (e) {
    print(e.message);
  }
}
