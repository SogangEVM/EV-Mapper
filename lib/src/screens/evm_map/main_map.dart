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
import 'dart:io' show Platform;

final startController = TextEditingController();
final goalController = TextEditingController();
final searchController = TextEditingController();
double currentLat = 37.566570;
double currentLng = 126.978442;
late NaverMapController mapController;
Set<PathOverlay> pathSet = Set();
late Stations stations;
List<Marker> allMarkerSet = [];
List<Marker> filteredMarkerSet = [];
late OverlayImage overlayImage;
late double currentZoomLevel;

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
    OverlayImage.fromAssetImage(assetName: 'images/marker.png').then((result) {
      overlayImage = result;
    });
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

  Marker marker(Station station) {
    return Marker(
      width: 30,
      height: 45,
      markerId: station.statId,
      position: LatLng(station.lat, station.lng),
      infoWindow: station.statNm,
      icon: overlayImage,
      onMarkerTab: (Marker? marker, Map<String, int?> mapper) async {
        _showInfoWindow = true;
        await mapController.getCameraPosition().then((value) {
          currentZoomLevel = value.zoom;
        });
        await mapController.moveCamera(
          CameraUpdate.toCameraPosition(
            CameraPosition(
              target: LatLng(station.lat, station.lng),
              zoom: currentZoomLevel,
            ),
          ),
        );
        await showStationInfo(context, currentLat, currentLng, station);
      },
    );
  }

  void _filtering(int type) {
    int chType;
    filteredMarkerSet = [];
    if (type == 0) {
      filteredMarkerSet = allMarkerSet;
    } else if (type == 1) {
      // DC차데모
      for (int i = 0; i < stations.stationList.length; i++) {
        chType = stations.stationList[i].chargerType;
        if (chType == 1 || chType == 3 || chType == 5 || chType == 6) {
          filteredMarkerSet.add(
            allMarkerSet[i],
          );
        }
      }
    } else if (type == 2) {
      // AC완속
      for (int i = 0; i < stations.stationList.length; i++) {
        chType = stations.stationList[i].chargerType;
        if (chType == 2) {
          filteredMarkerSet.add(
            allMarkerSet[i],
          );
        }
      }
    } else if (type == 4) {
      // DC콤보
      for (int i = 0; i < stations.stationList.length; i++) {
        chType = stations.stationList[i].chargerType;
        if (chType == 4 || chType == 5 || chType == 6) {
          filteredMarkerSet.add(
            allMarkerSet[i],
          );
        }
      }
    } else if (type == 7) {
      // AC3상
      for (int i = 0; i < stations.stationList.length; i++) {
        chType = stations.stationList[i].chargerType;
        if (chType == 3 || chType == 6 || chType == 7) {
          filteredMarkerSet.add(
            allMarkerSet[i],
          );
        }
      }
    }
    setState(() {});
    Navigator.of(context).pop();
  }

  // Function for fetch station markers
  Future<void> _fetchStation() async {
    EasyLoading.show(status: "환경관리공단 데이터를 불러오는중입니다");
    stations = await fetchStation();
    for (int i = 0; i < stations.stationList.length; i++) {
      Station station = stations.stationList[i];
      allMarkerSet.add(
        marker(station),
      );
    }
    filteredMarkerSet = allMarkerSet;
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
            setState(() {});
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
          markers: filteredMarkerSet,
        ),

        // Searching Bar
        SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.reorder_rounded,
                      color: evmColor.foregroundColor,
                    ),
                    onPressed: () {
                      showCupertinoDialog(
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return CupertinoAlertDialog(actions: [
                            CupertinoDialogAction(
                              child: Text("전체"),
                              onPressed: () {
                                _filtering(0);
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text("DC콤보"),
                              onPressed: () {
                                _filtering(4);
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text("DC차데모"),
                              onPressed: () {
                                _filtering(1);
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text("AC3상"),
                              onPressed: () {
                                _filtering(7);
                              },
                            ),
                            CupertinoDialogAction(
                              child: Text("AC완속"),
                              onPressed: () {
                                _filtering(2);
                              },
                            ),
                          ]);
                        },
                      );
                    },
                  ),
                  searchingBar(context),
                ],
              ),
            ),
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
