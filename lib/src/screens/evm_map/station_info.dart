import 'package:electric_vehicle_mapper/src/components/dialogs.dart';
import 'package:electric_vehicle_mapper/src/services/fetch_path.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:electric_vehicle_mapper/src/models/paths.dart';
import 'package:electric_vehicle_mapper/src/models/station.dart';

List<String> status = [
  "오류",
  "통신이상",
  "충전대기",
  "충전중",
  "운영중지",
  "점검중",
  "오류",
  "오류",
  "오류",
  "상태미확인"
];
List<Color> statusColor = [
  Colors.red,
  Colors.red,
  Colors.blueAccent,
  Colors.green,
  Colors.grey,
  Colors.grey,
  Colors.red,
  Colors.red,
  Colors.red,
  Colors.orangeAccent,
];
List<String> chargerType = [
  "오류",
  "DC차데모"
      "AC완속",
  "DC차데모+AC3상",
  "DC콤보",
  "DC차데모+DC콤보",
  "DC차데모+AC3상+DC콤보",
  "AC3상"
];

Future<List<String>> _fetchPathInfo(BuildContext context, double currentLat,
    double currentLng, Station station) async {
  List<String> str = [];
  Paths path = await fetchPath(
      "${currentLng},${currentLat}", "${station.lng},${station.lat}");

  int km = (path.distance / 1000).floor();
  int m = ((path.distance - km * 1000) / 100).floor();
  String distance = "${km}.${m}";

  int hour = (path.duration / 3600).floor();
  int minute = ((path.duration - hour * 3600) / 60).floor();
  String duration;
  if (hour > 0)
    duration = "${hour}시간 ${minute}분 ";
  else
    duration = "${minute}분 ";
  str.add(distance);
  str.add(duration);
  return str;
}

Future<void> showStationInfo(BuildContext context, double currentLat,
    double currentLng, Station station) async {
  Widget infoWidget = FutureBuilder(
    future: _fetchPathInfo(context, currentLat, currentLng, station),
    builder: (BuildContext context, AsyncSnapshot snapshot) {
      if (snapshot.hasData == false) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: CircularProgressIndicator(),
            ),
          ],
        );
      } else if (snapshot.hasError) {
        return Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Error: ${snapshot.error}',
            style: TextStyle(fontSize: 15),
          ),
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Text(
                      station.statNm,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Icon(Icons.near_me, size: 20),
                Text(snapshot.data[0] + "Km"),
                Spacer(),
                Icon(Icons.star_border_outlined),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  station.useTime.isEmpty
                      ? "정보없음"
                      : "(" + station.useTime + ")",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            // Text(station.addr),
            Container(
              width: MediaQuery.of(context).size.width * 0.9,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  station.addr.isEmpty ? "정보없음" : station.addr,
                ),
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: [
                Text(
                  status[station.stat],
                  style: TextStyle(
                    color: statusColor[station.stat],
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(chargerType[station.chargerType]),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Center(
              child: ElevatedButton(
                style: ButtonStyle(),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    snapshot.data[1] + "안내 시작",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  selectNavigationDialog(
                      context, station.statNm, station.lat, station.lng);
                },
              ),
            ),
          ],
        );
      }
    },
  );

  showBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
    ),
    builder: (context) => Container(
      height: 175.0,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 20, 20, 5),
        child: infoWidget,
      ),
    ),
  );
}
