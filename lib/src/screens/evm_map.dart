import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:kakao_flutter_sdk/local.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/navi.dart';
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

class EvmMap extends StatefulWidget {
  const EvmMap({Key? key}) : super(key: key);

  @override
  _EVMMapState createState() => _EVMMapState();
}

class _EVMMapState extends State<EvmMap> {
  //late final NaverMapController _mapController;
  static const platform = const MethodChannel("samples.flutter.dev/tmapInvoke");
  double currentLng = 126.978442;
  double currentLat = 37.566570;
  bool _nightModeEnable = false;

  @override
  void initState() {
    super.initState();
    KakaoContext.clientId = "4b9a4abdfc5d02f9b075402afb3d754e";
  }

  Future<void> _invokeTMap() async {
    try {
      await platform.invokeMethod(
          "tmapInvoke", {"lng": "126.978442", "lat": "37.566570"});
    } on PlatformException catch (e) {
      print(e.message);
    }
  }

  Future<void> _kakaoNavigationButtonClicked() async {
    try {
      bool ap = await NaviApi.instance.isKakaoNaviInstalled();

      print(ap.toString());
      var url = await NaviApi.instance.navigateWebUrl(
          Location('asc', "126.978442", "37.566570"),
          option: NaviOption(coordType: NaviCoordType.WGS84));
      print(url);
      await launchBrowserTab(url);
    } catch (e) {
      print(e);
    }
  }

  Future<void> _tMapNavigationButtonClicked() async {
    await _invokeTMap();
  }

  Future<void> _getPosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    try {
      currentLng = position.longitude;
      currentLat = position.latitude;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<void> _moveCurrentPosition() async {
    await _getPosition();
    final _cameraUpdate = CameraUpdate.scrollTo(LatLng(currentLat, currentLng));
    await _mapController.moveCamera(_cameraUpdate);
    await _mapController.setLocationTrackingMode(LocationTrackingMode.Follow);
  }

  Future<void> _changeMapMode() async {
    setState(() {
      _nightModeEnable = !_nightModeEnable;
    });
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
            await _moveCurrentPosition();
          },
          mapType: MapType.Navi,
          nightModeEnable: _nightModeEnable,
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
              // IconButton(
              //   icon: Icon(Icons.add),
              //   onPressed: () async {
              //     await _kakaoNavigationButtonClicked();
              //   },
              // ),
              TextButton(
                child: Text("Tmap안내"),
                onPressed: () async {
                  await _tMapNavigationButtonClicked();
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
                zoomButton('in'),
                zoomButton('out'),
              ],
            ),
          ),
        ),

        // Current Locatin, Night Mode, Favorites Buttons
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  mini: true,
                  child:
                      Icon(Icons.my_location, color: evmColor.backgroundColor),
                  onPressed: () async {
                    await _moveCurrentPosition();
                  },
                ),
                FloatingActionButton(
                  mini: true,
                  child: _nightModeEnable
                      ? Icon(
                          Icons.nightlight,
                          color: evmColor.backgroundColor,
                        )
                      : Icon(
                          Icons.nightlight_outlined,
                          color: evmColor.backgroundColor,
                        ),
                  onPressed: () {
                    _changeMapMode();
                  },
                ),
                FloatingActionButton(
                  mini: true,
                  child: Icon(
                    Icons.star_rounded,
                    color: evmColor.backgroundColor,
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
                '충전소/지역명 검색',
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
    width: 36.0,
    height: 38.0,
    child: TextButton(
      style: ButtonStyle(alignment: Alignment.center),
      onPressed: () async {
        type == 'in' ? await _zoomIn() : await _zoomOut();
      },
      child: Icon(type == 'in' ? Icons.add_sharp : Icons.remove_sharp,
          size: 18.0, color: evmColor.backgroundColor),
    ),
  );
}
