import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:electric_vehicle_mapper/src/models/paths.dart';

Future<Paths> fetchPath(String start, String dest) async {
  String kakaonaviUrl = 'https://apis-navi.kakaomobility.com/v1/directions';
  String queryString = 'origin=' + start + '&destination=' + dest;
  var headers = {'Authorization': 'KakaoAK 627e439f486db8af2cc738abff5dfab1'};
  //String queryString = Uri(queryParameters: queryParams).toString();
  var requestUrl = Uri.parse(kakaonaviUrl + '?' + queryString);

  //print(queryString);
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
