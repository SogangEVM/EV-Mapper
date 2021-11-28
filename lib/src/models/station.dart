// ignore: import_of_legacy_library_into_null_safe
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:xml/xml.dart';

class Stations {
  List<Marker> stations;

  Stations({
    required this.stations,
  });

  factory Stations.fromXml(String xml) {
    final root = XmlDocument.parse(xml)
        .getElement('response')!
        .getElement('body')!
        .getElement('item')!;
    final markers = root.findAllElements('item');
    for (int i = 0; i < markers.length; i++) {
      print(markers.elementAt(i).toString());
    }
    final List<Marker> markerList = [];
    // for(int i = 0; i < markers.length; i++) {
    //   markerList.add(
    //     Marker(markerId: markers[i]['statId'], position: position)
    //   )
    // }
    return Stations(
      stations: [],
    );
  }
}

// class Station {
//   final String stataNm;
//   final String statId;
//   final String addr;
//   final double lat;
//   final double lng;

//   Station({
//     required this.stataNm,
//     required this.statId,
//     required this.addr,
//     required this.lat,
//     required this.lng,
//   });

//   factory Station.fromJson(Map<String, dynamic> json) {
//     List<dynamic> path = json['route']['traoptimal'][0]['path'];
//     final List<LatLng> pathList = [];
//     for (int i = 0; i < path.length; i++) {
//       pathList.add(LatLng(path[i][1], path[i][0]));
//     }
//     return Station(
//       stationId: json['resultCode'],
//       latitude: pathList,
//       longitude: 0,
//     );
//   }
// }
