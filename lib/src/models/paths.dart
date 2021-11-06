// ignore: import_of_legacy_library_into_null_safe
import 'package:naver_map_plugin/naver_map_plugin.dart';

class Paths {
  final int code;
  final List<LatLng> path;
  Paths({
    required this.code,
    required this.path,
  });

  factory Paths.fromJson(Map<String, dynamic> json) {
    List<dynamic> path = json['route']['traoptimal'][0]['path'];
    final List<LatLng> pathList = [];
    for (int i = 0; i < path.length; i++) {
      pathList.add(LatLng(path[i][1], path[i][0]));
    }
    return Paths(
      code: json['code'],
      path: pathList,
    );
  }

  factory Paths.fromKakao(Map<String, dynamic> json) {
    List<dynamic> roads = json["routes"][0]["sections"][0]["roads"];
    int resultCode;
    List<LatLng> pathList = [];

    resultCode = json["routes"][0]["result_code"];
    for (int i = 0; i < roads.length; i++) {
      List<dynamic> vertexes = roads[i]["vertexes"];
      for (int j = 0; j < vertexes.length / 2; j++) {
        pathList.add(LatLng(vertexes[j * 2 + 1], vertexes[j * 2]));
      }
    }
    return Paths(
      code: resultCode,
      path: pathList,
    );
  }
}
