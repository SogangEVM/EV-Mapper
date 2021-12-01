import 'package:electric_vehicle_mapper/src/screens/evm_map/station_info.dart';
import 'package:electric_vehicle_mapper/src/services/fetch_path.dart';
import 'package:electric_vehicle_mapper/src/services/fetch_station.dart';
import 'package:electric_vehicle_mapper/src/models/paths.dart';
import 'package:electric_vehicle_mapper/src/models/station.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:location/location.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:electric_vehicle_mapper/src/screens/evm_map/searching_bar.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'dart:math';

final startController = TextEditingController();
final goalController = TextEditingController();
final searchController = TextEditingController();
double currentLat = 37.566570;
double currentLng = 126.978442;
late NaverMapController mapController;
Set<PathOverlay> pathSet = Set();
late Stations stations;
List<Marker> allMarkerSet = [];
List<Marker> markerSet = [];

var stationInfo = Map();

bool darkMode = false;
late OverlayImage markerIcon;

class EvmMap extends StatefulWidget {
  const EvmMap({Key? key}) : super(key: key);

  @override
  _EVMMapState createState() => _EVMMapState();
}

class _EVMMapState extends State<EvmMap> {
  bool _showInfoWindow = false;

  @override
  void initState() {
    super.initState();
    _fetchStation().then((result) {});
  }

  // Function for draw path on Navermap
  Future<void> _drawPath(double destLat, double destLng) async {
    Paths _paths =
        await fetchPath("${currentLng},${currentLat}", "${destLng},${destLat}");
    PathOverlay _pathOverlay = PathOverlay(PathOverlayId('1'), _paths.path);
    _pathOverlay.color = evmColor.foregroundColor;
    double _latDiffer = (currentLat - destLat).abs() / 2;
    double _lngDiffer = (currentLng - destLng).abs() / 2;
    LatLngBounds _bounds = LatLngBounds(
        southwest: LatLng(min(currentLat, destLat) - _latDiffer,
            min(currentLng, destLng) - _lngDiffer),
        northeast: LatLng(max(currentLat, destLat) + _latDiffer,
            max(currentLng, destLng) + _lngDiffer));
    CameraUpdate _cameraUpdate = CameraUpdate.fitBounds(_bounds);
    await mapController.moveCamera(_cameraUpdate);

    setState(() {
      pathSet.add(_pathOverlay);
    });
  }

  // Function for fetch station markers
  Future<void> _fetchStation() async {
    EasyLoading.show(status: "환경관리공단 데이터 불러오는중...");
    stations = await fetchStation();
    for (int i = 0; i < stations.stationList.length; i++) {
      Station station = stations.stationList[i];
      allMarkerSet.add(
        Marker(
            markerId: station.statId,
            position: LatLng(station.lat, station.lng),
            iconTintColor: Color(0xff0000cc),
            infoWindow: station.statNm,
            onMarkerTab: (Marker? marker, Map<String, int?> mapper) async {
              _showInfoWindow = true;
              await mapController.moveCamera(
                CameraUpdate.toCameraPosition(
                  CameraPosition(
                    target: LatLng(station.lat, station.lng),
                    zoom: 12.0,
                  ),
                ),
              );
              await showStationInfo(context, currentLat, currentLng, station);
            }),
      );
    }
    setState(() {});
    EasyLoading.dismiss();
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
    currentLat = _location.latitude!;
    currentLng = _location.longitude!;
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
          onMapTap: (contorller) {
            if (_showInfoWindow) {
              Navigator.pop(context);
              _showInfoWindow = false;
            }
          },
          mapType: MapType.Navi,
          nightModeEnable: darkMode,
          locationButtonEnable: true,
          pathOverlays: pathSet,
          initLocationTrackingMode: LocationTrackingMode.Follow,
          initialCameraPosition: CameraPosition(
            target: LatLng(currentLat, currentLng),
            zoom: 12,
          ),
          markers: allMarkerSet,
        ),

        // Searching Bar
        searchingBar(context),

        Align(
          alignment: Alignment.centerLeft,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text("필터링"),
                onPressed: () {
                  setState(() {
                    List<Marker> temp = allMarkerSet;
                    allMarkerSet = [];
                    for (int i = 0; i < temp.length; i++) {
                      if (temp[i].markerId == '1') allMarkerSet.add(temp[i]);
                    }
                  });
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
                  child: Icon(
                    Icons.refresh_rounded,
                    color: evmColor.foregroundColor,
                  ),
                  onPressed: () async {
                    await _fetchStation();
                  },
                ),
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
