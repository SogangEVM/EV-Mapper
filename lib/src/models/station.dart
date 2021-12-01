import 'package:xml/xml.dart';

class Stations {
  List<Station> stationList;

  Stations({
    required this.stationList,
  });

  factory Stations.fromXml(XmlDocument xmlDocument) {
    // Map stationMap = Map();
    List<Station> stationList = [];
    final items = xmlDocument.findAllElements('item');

    items.forEach((element) {
      Station station;
      station = Station(
        statId: element.getElement('statId')!.text,
        statNm: element.getElement('statNm')!.text,
        addr: element.getElement('addr')!.text,
        lat: double.parse(element.getElement('lat')!.text),
        lng: double.parse(element.getElement('lng')!.text),
        chargerType: int.parse(element.getElement('chgerType')!.text),
        useTime: element.getElement('useTime')!.text,
        stat: int.parse(element.getElement('stat')!.text),
      );
      stationList.add(station);
    });
    return Stations(
      // stationMap: stationMap,
      // stationMarker: null,
      stationList: stationList,
    );
  }

  // factory Stations.fromJson(Map<String, dynamic> json) {
  //   Map<String, Station> stationMap = Map();
  //   //List<dynamic> stations = json;
  //   List<Marker> stationMarkerList = [];

  //   for (int i = 0; i < json['stations'].length; i++) {
  //     stationMap[json['stations'][i]['statid'].toString()] =
  //         Station.fromJson(json['stations'][i]);
  //     print(json['stations'][i]['addr']);
  //     stationMarkerList.add(
  // Marker(
  //   markerId: json['stations'][i]['statid'],
  //   position:
  //       LatLng(json['stations'][i]['lat'], json['stations'][i]['lng']),
  //   captionText: json['stations'][i]['statnm'],
  //   captionMinZoom: 11,
  //   iconTintColor: Color(0xff1500ff),
  //   onMarkerTab: (Marker? marker, Map<String, int?> mapper) {
  //     // _showInfoWindow = true;
  //     // showStationInfo(context, stationSet.stations[i]);
  //   },
  // ),
  //     );
  //   }
  //   return Stations(
  //     stationMap: stationMap,
  //     stationMarkerList: stationMarkerList,
  //     stationList: stationList,
  //   );
  // }
}

class Station {
  final String statNm;
  final String statId;
  final String addr;
  final double lat;
  final double lng;
  final int chargerType;
  final String useTime;
  final int stat;

  Station({
    required this.statNm,
    required this.statId,
    required this.addr,
    required this.lat,
    required this.lng,
    required this.chargerType,
    required this.useTime,
    required this.stat,
  });
}
