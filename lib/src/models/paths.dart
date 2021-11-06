// ignore: import_of_legacy_library_into_null_safe
import 'package:naver_map_plugin/naver_map_plugin.dart';

class Paths {
  final int resultCode;
  final List<LatLng> path;
  final int distance;
  final int duration;

  Paths({
    required this.resultCode,
    required this.path,
    required this.distance,
    required this.duration,
  });

  factory Paths.fromJson(Map<String, dynamic> json) {
    List<dynamic> path = json['route']['traoptimal'][0]['path'];
    final List<LatLng> pathList = [];
    for (int i = 0; i < path.length; i++) {
      pathList.add(LatLng(path[i][1], path[i][0]));
    }
    return Paths(
      resultCode: json['resultCode'],
      path: pathList,
      distance: 0,
      duration: 0,
    );
  }

  factory Paths.fromKakao(Map<String, dynamic> json) {
    List<dynamic> roads = json["routes"][0]["sections"][0]["roads"];
    List<LatLng> pathList = [];
    int resultCode = json["routes"][0]["result_code"];
    int distance = json["routes"][0]["summary"]["distance"];
    int duration = json["routes"][0]["summary"]["duration"];

    for (int i = 0; i < roads.length; i++) {
      List<dynamic> vertexes = roads[i]["vertexes"];
      for (int j = 0; j < vertexes.length / 2; j++) {
        pathList.add(LatLng(vertexes[j * 2 + 1], vertexes[j * 2]));
      }
    }
    return Paths(
      resultCode: resultCode,
      path: pathList,
      distance: distance,
      duration: duration,
    );
  }
}
