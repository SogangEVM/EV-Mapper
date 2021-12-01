import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:electric_vehicle_mapper/src/models/station.dart';
import 'package:xml/xml.dart';

Future<Stations> fetchStation() async {
  String stationUrl = "http://apis.data.go.kr/B552584/EvCharger/getChargerInfo";
  String serviceKey =
      "ServiceKey=5I4HAS4TDAPOOjW7RWQbNjNYlgTY0QRS1F5jMXFiR%2FwFjOeC57iCzUrefQ3t4jFMirvTIf4P0AAfMEMc0Q%2BsLA%3D%3D";
  var requestUrl =
      Uri.parse(stationUrl + "?" + serviceKey + "&pageNo=1&numOfRows=9999");

  final response = await http.get(
    requestUrl,
  );
  if (response.statusCode == 200) {
    // final parsed = await json.decode(utf8.decode(response.bodyBytes));
    final xmlDocument = XmlDocument.parse(response.body);
    // return Stations.fromJson(parsed);
    return Stations.fromXml(xmlDocument);
  } else {
    throw Exception("Unable to perform fetch route request!");
  }
}
