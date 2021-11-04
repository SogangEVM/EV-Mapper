import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:store_redirect/store_redirect.dart';
import 'dart:io' show Platform;
// ignore: import_of_legacy_library_into_null_safe
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:electric_vehicle_mapper/src/models/paths.dart';
import 'package:electric_vehicle_mapper/src/services/direction5.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;

final startController = TextEditingController();
final goalController = TextEditingController();
final searchController = TextEditingController();
late final _mapController;
Set<PathOverlay> pathSet = Set();
bool darkMode = false;

class EvmMap extends StatefulWidget {
  const EvmMap({Key? key}) : super(key: key);

  @override
  _EVMMapState createState() => _EVMMapState();
}

class _EVMMapState extends State<EvmMap> {
  //late final NaverMapController _mapController;
  static const _tmapChannel =
      const MethodChannel("electric_vehicle_mapper/tmapChannel");
  static const _kakaoNaviChannel =
      const MethodChannel("electric_vehicle_mapper/kakaonaviChannel");
  double currentLat = 37.566570;
  double currentLng = 126.978442;

  @override
  void initState() {
    super.initState();
  }

  void _showNotInstalledDialog(bool result, String title, String content,
      String androidId, String iOSId) {
    Widget _titleMessage = Text(title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));

    Widget _contentMessage = Padding(
      padding: EdgeInsets.only(
        top: 10.0,
      ),
      child: Text(content),
    );

    Widget _confirmButton = TextButton(
      child: Text("확인"),
      onPressed: () {
        Navigator.pop(context);
        StoreRedirect.redirect(
          androidAppId: androidId,
          iOSAppId: iOSId,
        );
      },
    );

    Widget _cancelButton = TextButton(
      child: Text("취소"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    if (!result)
      Platform.isAndroid
          ? showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: _titleMessage,
                  content: _contentMessage,
                  actions: [
                    _cancelButton,
                    _confirmButton,
                  ],
                );
              })
          : showCupertinoDialog(
              barrierDismissible: true,
              context: context,
              builder: (BuildContext context) {
                return CupertinoAlertDialog(
                  title: _titleMessage,
                  content: _contentMessage,
                  actions: [
                    _cancelButton,
                    _confirmButton,
                  ],
                );
              });
  }

  Future<void> _invokeKakaonavi() async {
    try {
      var result = await _kakaoNaviChannel.invokeMethod("invokeKakaonavi", {
        "destination": "dest",
        "startLat": currentLat.toString(),
        "startLng": currentLng.toString(),
        "destLat": "37.566570",
        "destLng": "126.978442"
      });
      _showNotInstalledDialog(result, "카카오내비가 설치되어 있지 않습니다.",
          "카카오내비를 설치하시겠습니까?", "com.locnall.KimGiSa", "417698849");
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _invokeTmap() async {
    try {
      var result = await _tmapChannel.invokeMethod("invokeTmap",
          {"destination": "dest", "lat": "37.566570", "lng": "126.978442"});
      _showNotInstalledDialog(result, "TMAP이 설치되어 있지 않습니다.", "TMAP을 설치하시겠습니까?",
          "com.skt.tmap.ku", "431589174");
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _changeMapMode() async {
    setState(() {
      darkMode = !darkMode;
    });
  }

  Future<void> _getLocation() async {
    LocationData location = await Location().getLocation();
    currentLat = location.latitude!;
    currentLng = location.longitude!;
  }

  Future<void> _moveCurrentPosition() async {
    await _getLocation();
    final _cameraUpdate = CameraUpdate.scrollTo(LatLng(currentLat, currentLng));
    await _mapController.moveCamera(_cameraUpdate);
    await _mapController.setLocationTrackingMode(LocationTrackingMode.Follow);
  }

  Future<void> drawRoute() async {
    Paths paths = await fetchRoute(startController.text, goalController.text);
    PathOverlay pathOverlay = PathOverlay(PathOverlayId('1'), paths.path);
    setState(() {
      pathSet.add(pathOverlay);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // NAVER Map
        NaverMap(
          onMapCreated: (controller) async {
            _mapController = controller;
            DateTime before = DateTime.now();
            print("위치읽기중");
            await _getLocation();
            DateTime after = DateTime.now();
            print(after.difference(before).inSeconds);
            print("위치읽기성공");
          },
          mapType: MapType.Navi,
          nightModeEnable: darkMode,
          locationButtonEnable: true,
          pathOverlays: pathSet,
          initLocationTrackingMode: LocationTrackingMode.Follow,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLat, currentLng),
            zoom: 13,
          ),
        ),

        // Searching Bar
        SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: PlaceFindTextField(),
          ),
        ),

        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text("Kakaonavi안내"),
                onPressed: () async {
                  await _invokeKakaonavi();
                },
              ),
              TextButton(
                child: Text("Tmap안내"),
                onPressed: () async {
                  await _invokeTmap();
                },
              ),
            ],
          ),
        ),

        // Zoom In, Out Button
        Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                zoomButton("in"),
                zoomButton("out"),
              ],
            ),
          ),
        ),

        // Night Mode, Favorites Buttons
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  mini: true,
                  child: darkMode
                      ? Icon(
                          Icons.nightlight,
                          color: evmColor.foregroundColor,
                        )
                      : Icon(
                          Icons.nightlight_outlined,
                          color: evmColor.foregroundColor,
                        ),
                  onPressed: () async {
                    await _changeMapMode();
                  },
                ),
                FloatingActionButton(
                  mini: true,
                  child: Icon(
                    Icons.star_rounded,
                    color: evmColor.foregroundColor,
                  ),
                  onPressed: () {
                    showCupertinoModalBottomSheet(
                      context: context,
                      builder: (context) => Container(),
                    );
                  },
                ),
                SizedBox(
                  height: 10.0,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class PlaceFindTextField extends StatefulWidget {
  const PlaceFindTextField({Key? key}) : super(key: key);

  @override
  _PlaceFindTextFieldState createState() => _PlaceFindTextFieldState();
}

class _PlaceFindTextFieldState extends State<PlaceFindTextField> {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.4,
            color: evmColor.foregroundColor,
          ),
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Text(
                "충전소/지역명 검색",
                style: TextStyle(
                  color: evmColor.backgroundColor,
                ),
              ),
              Spacer(),
              Icon(Icons.search, color: evmColor.foregroundColor),
            ],
          ),
        ),
      ),
      onPressed: () {
        showCupertinoModalBottomSheet(
          context: context,
          builder: (context) => Container(),
        );
      },
    );
  }
}

Widget zoomButton(String type) {
  _zoomIn() async {
    final _cameraUpdate = CameraUpdate.zoomIn();
    _mapController.moveCamera(_cameraUpdate);
  }

  _zoomOut() async {
    final _cameraUpdate = CameraUpdate.zoomOut();
    _mapController.moveCamera(_cameraUpdate);
  }

  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(
        width: 0.1,
        color: evmColor.backgroundColor,
      ),
    ),
    width: 38.0,
    height: 40.0,
    child: TextButton(
      style: ButtonStyle(alignment: Alignment.center),
      onPressed: () async {
        type == "in" ? await _zoomIn() : await _zoomOut();
      },
      child: Icon(type == "in" ? Icons.add_sharp : Icons.remove_sharp,
          size: 18.0, color: evmColor.backgroundColor),
    ),
  );
}
