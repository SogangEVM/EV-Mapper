import 'package:electric_vehicle_mapper/src/screens/evm_map/main_map.dart';
import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:electric_vehicle_mapper/src/models/station.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';

Widget searchingBar(BuildContext context) {
  return TextButton(
    child: Container(
      width: MediaQuery.of(context).size.width * 0.7,
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
        builder: (context) => searchScreen(),
      );
    },
  );
}

class searchScreen extends StatefulWidget {
  const searchScreen({Key? key}) : super(key: key);

  @override
  _searchScreenState createState() => _searchScreenState();
}

class _searchScreenState extends State<searchScreen> {
  final TextEditingController _filter = TextEditingController();
  FocusNode focusNode = FocusNode();
  String _searchText = "";

  _searchScreenState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Station> suggestionList = [];
    _filter.text.isEmpty
        ? suggestionList = []
        : suggestionList.addAll(stations.stationList.where(
            (element) => element.statNm.contains(_filter.text),
          ));
    return Container(
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
            child: Row(
              children: [
                Expanded(
                  flex: 6,
                  child: TextField(
                    focusNode: focusNode,
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                    autofocus: true,
                    controller: _filter,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.search,
                        color: evmColor.foregroundColor,
                      ),
                      suffixIcon: focusNode.hasFocus
                          ? IconButton(
                              icon: Icon(
                                Icons.cancel,
                                size: 20.0,
                                color: evmColor.foregroundColor,
                              ),
                              onPressed: () {
                                setState(() {
                                  _filter.clear();
                                  _searchText = "";
                                });
                              },
                            )
                          : Container(),
                      hintText: "충전소 검색",
                    ),
                  ),
                ),
              ],
            ),
          ),
          // ListView.builder(
          //   itemCount: suggestionList.length,
          //   itemBuilder: (context, index) {
          //     return ListTile(
          //       title: Text(
          //         suggestionList[index].statNm,
          //       ),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }
}
