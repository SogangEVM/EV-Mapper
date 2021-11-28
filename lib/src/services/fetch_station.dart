import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:electric_vehicle_mapper/src/models/station.dart';

Future<Stations> fetchStation() async {
  String stationUrl = 'http://apis.data.go.kr/B552584/EvCharger/getChargerInfo';
  String serviceKey =
      '5I4HAS4TDAPOOjW7RWQbNjNYlgTY0QRS1F5jMXFiR%2FwFjOeC57iCzUrefQ3t4jFMirvTIf4P0AAfMEMc0Q%2BsLA%3D%3D';
  // String encodeKey =
  //     'ServiceKey=5I4HAS4TDAPOOjW7RWQbNjNYlgTY0QRS1F5jMXFiR%2FwFjOeC57iCzUrefQ3t4jFMirvTIf4P0AAfMEMc0Q%2BsLA%3D%3D';
  var requestUrl = Uri.parse(stationUrl + '?' + 'ServiceKey=' + serviceKey);

  //print(queryString);
  final response = await http.get(
    requestUrl,
  );
  if (response.statusCode == 200) {
    return Stations.fromXml(response.body);
  } else {
    throw Exception("Unable to perform fetch route request!");
  }
}
