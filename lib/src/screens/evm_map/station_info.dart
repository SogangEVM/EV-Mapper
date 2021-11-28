import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:electric_vehicle_mapper/src/components/dialogs.dart';

Future<void> showStationInfo(BuildContext context) async {
  showBottomSheet(
    context: context,
    // backgroundColor: Colors.red,
    // barrierColor: Colors.transparent,
    //useRootNavigator: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0)),
    ),
    builder: (context) => Container(
      height: 175.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     IconButton(
            //       icon: Icon(Icons.cancel),
            //       onPressed: () {
            //         Navigator.pop(context);
            //       },
            //     ),
            //   ],
            // ),
            Row(
              children: [
                Text(
                  "서울마포 코오롱하늘채아파트 A단지",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                Spacer(),
                Icon(Icons.star_border_outlined),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Text("서울 마포구 연남로 52"),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  "상태미확인",
                  style: TextStyle(
                    color: Colors.orangeAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text("완속 0/1"),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Center(
              child: ElevatedButton.icon(
                style: ButtonStyle(),
                icon: Icon(Icons.near_me, size: 20),
                label: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Text(
                    "0.5KM 안내 시작",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onPressed: () {
                  selectNavigationDialog(context);
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
