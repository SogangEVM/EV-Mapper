// import 'package:geolocator/geolocator.dart';

// class MyLocation {
//   double? latitude;
//   double? longitude;

//   Future<void> getLocation() async {
//     Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.best);
//     try {
//       latitude = position.latitude;
//       longitude = position.longitude;
//     } on PlatformException catch (e) {
//       print(e);
//     }
//   }
// }