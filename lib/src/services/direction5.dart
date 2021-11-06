import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:electric_vehicle_mapper/main.dart';
import 'package:electric_vehicle_mapper/src/models/paths.dart';

Future<Paths> fetchRo(String start, String goal) async {
  String direction5Url =
      'https://naveropenapi.apigw.ntruss.com/map-direction/v1/driving';
  Map<String, String> queryParams = {
    'start': start,
    'goal': goal,
  };
  var headers = {
    'X-NCP-APIGW-API-KEY-ID': clientId,
    'X-NCP-APIGW-API-KEY': clientSecret,
  };
  String queryString = Uri(queryParameters: queryParams).query;
  var requestUrl = Uri.parse(direction5Url + '?' + queryString);

  final response = await http.get(
    requestUrl,
    headers: headers,
  );
  if (response.statusCode == 200) {
    final parsed = await json.decode(response.body);
    return Paths.fromJson(parsed);
  } else {
    throw Exception("Unable to perform fetch route request!");
  }
}
