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

final startController = TextEditingController();
final goalController = TextEditingController();
final searchController = TextEditingController();
double currentLat = 37.566570;
double currentLng = 126.978442;
late NaverMapController mapController;
Set<PathOverlay> pathSet = Set();
//List<Station> stationSet = [];
List<Marker> allMarkerSet = [];
List<Marker> markerSet = [];
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
    setState(() {
      allMarkerSet = [
        Marker(
          markerId: '1',
          position: LatLng(37.5577362206, 126.9178351068),
          captionText: '코오롱 하늘채 a단지',
          captionMinZoom: 11,
          iconTintColor: Color(0xff1500ff),
          onMarkerTab: (Marker? marker, Map<String, int?> mapper) {
            _showInfoWindow = true;
            showStationInfo(context);
            print(marker!.markerId.toString());
            print(mapper['width'].toString());
            setState(() {
              marker.width = 100;
              marker.height = 100;
              mapper['width'] = 100;
              mapper['height'] = 100;
            });
          },
        ),
        Marker(markerId: '2', position: LatLng(37.5648202770, 126.9201570654)),
        Marker(markerId: '3', position: LatLng(37.5637954434, 126.9082018741)),
        Marker(markerId: '4', position: LatLng(37.5603113438, 126.9023171320)),
        Marker(markerId: '5', position: LatLng(37.5603473521, 126.9002320696)),
        Marker(markerId: '6', position: LatLng(37.5608435385, 126.9320907521)),
      ];
    });
  }

  // Function for draw path on Navermap
  // Future<void> _drawPath(double destLat, double destLng) async {
  //   Paths _paths = await fetchPath(
  //       "${_currentLng},${_currentLat}", "${destLng},${destLat}");
  //   PathOverlay _pathOverlay = PathOverlay(PathOverlayId('1'), _paths.path);
  //   _pathOverlay.color = evmColor.foregroundColor;
  //   double _latDiffer = (_currentLat - destLat).abs() / 2;
  //   double _lngDiffer = (_currentLng - destLng).abs() / 2;
  //   LatLngBounds _bounds = LatLngBounds(
  //       southwest: LatLng(min(_currentLat, destLat) - _latDiffer,
  //           min(_currentLng, destLng) - _lngDiffer),
  //       northeast: LatLng(max(_currentLat, destLat) + _latDiffer,
  //           max(_currentLng, destLng) + _lngDiffer));
  //   CameraUpdate _cameraUpdate = CameraUpdate.fitBounds(_bounds);
  //   await mapController.moveCamera(_cameraUpdate);

  //   setState(() {
  //     pathSet.add(_pathOverlay);
  //   });
  // }

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
            zoom: 13,
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
                child: Text("station"),
                onPressed: () async {
                  await fetchStation();
                },
              ),
              TextButton(
                child: Text('필터링'),
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
