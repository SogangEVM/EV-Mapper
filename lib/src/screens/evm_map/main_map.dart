import 'dart:io' show Platform;
import 'dart:math';
import 'package:electric_vehicle_mapper/src/services/fetch_path.dart';
import 'package:electric_vehicle_mapper/src/models/paths.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:store_redirect/store_redirect.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:electric_vehicle_mapper/src/screens/evm_map/searching_bar.dart';

final startController = TextEditingController();
final goalController = TextEditingController();
final searchController = TextEditingController();
late NaverMapController mapController;
Set<PathOverlay> pathSet = Set();
bool darkMode = false;

class EvmMap extends StatefulWidget {
  const EvmMap({Key? key}) : super(key: key);

  @override
  _EVMMapState createState() => _EVMMapState();
}

class _EVMMapState extends State<EvmMap> {
  static const _tmapChannel =
      const MethodChannel("electric_vehicle_mapper/tmapChannel");
  static const _kakaoNaviChannel =
      const MethodChannel("electric_vehicle_mapper/kakaonaviChannel");
  double _currentLat = 37.566570;
  double _currentLng = 126.978442;

  @override
  void initState() {
    super.initState();
  }

  // Function for invoke kakaonavi application
  Future<void> _invokeKakaonavi(
      String destination, double destLat, double destLng) async {
    try {
      var result = await _kakaoNaviChannel.invokeMethod("invokeKakaonavi", {
        "destination": destination,
        "startLat": "${_currentLat}",
        "startLng": "${_currentLng}",
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
  Future<void> _invokeTmap(
      String destination, double destLat, double destLng) async {
    try {
      var result = await _tmapChannel.invokeMethod("invokeTmap", {
        "destination": destination,
        "lat": "${destLat}",
        "lng": "${destLng}"
      });
      showNotInstalledDialog(context, result, "TMAP이 설치되어 있지 않습니다.",
          "TMAP을 설치하시겠습니까?", "com.skt.tmap.ku", "431589174");
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  // Function for draw path on Navermap
  Future<void> _drawPath(double destLat, double destLng) async {
    Paths _paths = await fetchPath(
        "${_currentLng},${_currentLat}", "${destLng},${destLat}");
    PathOverlay _pathOverlay = PathOverlay(PathOverlayId('1'), _paths.path);
    _pathOverlay.color = evmColor.foregroundColor;
    double _latDiffer = (_currentLat - destLat).abs() / 2;
    double _lngDiffer = (_currentLng - destLng).abs() / 2;
    LatLngBounds _bounds = LatLngBounds(
        southwest: LatLng(min(_currentLat, destLat) - _latDiffer,
            min(_currentLng, destLng) - _lngDiffer),
        northeast: LatLng(max(_currentLat, destLat) + _latDiffer,
            max(_currentLng, destLng) + _lngDiffer));
    CameraUpdate _cameraUpdate = CameraUpdate.fitBounds(_bounds);
    await mapController.moveCamera(_cameraUpdate);

    setState(() {
      pathSet.add(_pathOverlay);
    });
  }

  // Function for change Navermap mode
  Future<void> _changeMapMode() async {
    setState(() {
      darkMode = !darkMode;
    });
  }

  // Function for get user location
  Future<void> _getLocation() async {
    LocationData _location = await Location().getLocation();
    _currentLat = _location.latitude!;
    _currentLng = _location.longitude!;
  }

  Future<void> _addStationCard(BuildContext context) async {
    showBottomSheet(
      context: context,
      // backgroundColor: Colors.red,
      // barrierColor: Colors.transparent,
      //useRootNavigator: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
      ),
      builder: (context) => Container(
        height: 175.0,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    "서울마포 코오롱하늘채아파트 A단지",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.star_border_outlined),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Text("서울 마포구 연남로 52"),
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  Text(
                    "상태미확인",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Text("완속 0/1"),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: ElevatedButton.icon(
                  style: ButtonStyle(),
                  icon: Icon(Icons.near_me, size: 20),
                  label: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      "0.5KM 안내 시작",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onPressed: () {
                    showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(
                            content: Row(
                              children: [
                                Column(
                                  children: [
                                    TextButton(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image(
                                          image: AssetImage(
                                              'images/kakaonavi_icon.png'),
                                          width: 90.0,
                                          height: 90.0,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await _invokeKakaonavi(
                                            "서울마포 코오롱하늘채아파트 A단지",
                                            37.5648202770,
                                            126.9201570654);
                                      },
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text("카카오내비"),
                                  ],
                                ),
                                Spacer(),
                                Column(
                                  children: [
                                    TextButton(
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image(
                                          image: AssetImage(
                                              'images/tmap_icon.png'),
                                          width: 90.0,
                                          height: 90.0,
                                        ),
                                      ),
                                      onPressed: () async {
                                        Navigator.of(context).pop();
                                        await _invokeTmap("서울마포 코오롱하늘채아파트 A단지",
                                            37.5648202770, 126.9201570654);
                                      },
                                    ),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Text("티맵"),
                                  ],
                                ),
                              ],
                            ),
                          );
                        });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // NAVER Map
        NaverMap(
          onMapCreated: (controller) async {
            mapController = controller;
            DateTime before = DateTime.now();
            await _getLocation();
            DateTime after = DateTime.now();
            print(after.difference(before).inSeconds.toString() + "초 걸림");
          },
          mapType: MapType.Navi,
          nightModeEnable: darkMode,
          locationButtonEnable: true,
          pathOverlays: pathSet,
          initLocationTrackingMode: LocationTrackingMode.Follow,
          initialCameraPosition: CameraPosition(
            target: LatLng(_currentLat, _currentLng),
            zoom: 13,
          ),
          markers: [
            Marker(
                markerId: '1', position: LatLng(37.5577362206, 126.9178351068)),
            Marker(
                markerId: '2', position: LatLng(37.5648202770, 126.9201570654)),
            Marker(
                markerId: '3', position: LatLng(37.5637954434, 126.9082018741)),
            Marker(
                markerId: '4', position: LatLng(37.5603113438, 126.9023171320)),
            Marker(
                markerId: '5', position: LatLng(37.5603473521, 126.9002320696)),
            Marker(
                markerId: '6', position: LatLng(37.5608435385, 126.9320907521)),
          ],
        ),

        // Searching Bar
        searchingBar(context),

        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // TextButton(
              //   child: Text("도로생성"),
              //   onPressed: () async {
              //     await _drawPath(37.566570, 126.978442);
              //     //await drawRoute(37.225895, 127.071593);
              //   },
              // ),
              TextButton(
                child: Text("'"),
                onPressed: () async {
                  await _addStationCard(context);
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
                Container(
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
                      final _cameraUpdate = CameraUpdate.zoomIn();
                      await mapController.moveCamera(_cameraUpdate);
                    },
                    child: Icon(Icons.add_sharp,
                        size: 18.0, color: evmColor.backgroundColor),
                  ),
                ),
                Container(
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
                      final _cameraUpdate = CameraUpdate.zoomOut();
                      await mapController.moveCamera(_cameraUpdate);
                    },
                    child: Icon(Icons.remove_sharp,
                        size: 18.0, color: evmColor.backgroundColor),
                  ),
                ),
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

void showNotInstalledDialog(BuildContext context, bool result, String title,
    String content, String androidId, String iOSId) {
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