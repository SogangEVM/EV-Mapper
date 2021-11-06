import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:electric_vehicle_mapper/main.dart';
import 'package:electric_vehicle_mapper/src/models/paths.dart';

Future<Paths> fetchRoad(String start, String goal) async {
  //경도, 위도 순으로 넘겨줘야함
  String direction5Url = 'https://apis-navi.kakaomobility.com/v1/directions';
  Map<String, String> queryParams = {
    'origin': start,
    'destination': goal,
  };
  var headers = {'Authorization': 'KakaoAK 627e439f486db8af2cc738abff5dfab1'};
  String alpha = 'origin=' + start + '&destination=' + goal;
  String queryString = Uri(queryParameters: queryParams).query;
  var requestUrl = Uri.parse(direction5Url + '?' + alpha);

  print(queryString);
  print(requestUrl);
  final response = await http.get(
    requestUrl,
    headers: headers,
  );
  if (response.statusCode == 200) {
    final parsed = await json.decode(response.body);
    print(response.body);
    return Paths.fromKakao(parsed);
  } else {
    throw Exception("Unable to perform fetch route request!");
  }
}
