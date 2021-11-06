import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

Widget searchingBar(BuildContext context) {
  return SafeArea(
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
      child: TextButton(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.4,
              color: evmColor.foregroundColor,
            ),
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
          ),
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: [
                Text(
                  "충전소/지역명 검색",
                  style: TextStyle(
                    color: evmColor.backgroundColor,
                  ),
                ),
                Spacer(),
                Icon(Icons.search, color: evmColor.foregroundColor),
              ],
            ),
          ),
        ),
        onPressed: () {
          showCupertinoModalBottomSheet(
            context: context,
            builder: (context) => Container(),
          );
        },
      ),
    ),
  );
}
