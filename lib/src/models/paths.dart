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
}
