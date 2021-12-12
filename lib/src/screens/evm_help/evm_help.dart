import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;

class EvmHelp extends StatelessWidget {
  const EvmHelp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: evmColor.foregroundColor,
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                TabBar(
                  indicator: UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 3.0),
                    insets: EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 0.0),
                  ),
                  unselectedLabelColor: Colors.grey[400],
                  //labelColor: Colors.white,
                  tabs: [
                    Tab(
                      text: "충전요금",
                    ),
                    Tab(
                      text: "충전기종류",
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            chargeFee(),
            chargeType(),
          ],
        ),
      ),
    );
  }
}

Widget chargeFee() {
  return Padding(
    padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 0.0),
    child: SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "사업자별 금액",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: evmColor.foregroundColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Row(
            children: [
              SizedBox(
                width: 10.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "각 사업자별 자사 회원카드 이용 시, 급속 1kWh당 충전 가격입니다.",
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          DataTable(
            columns: [
              DataColumn(
                label: Text(
                  "충전 사업자",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "100kW 미만",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  "100kW 이상",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: [
              rowCell("환경부", "292.9원", "309.1원"),
              rowCell("한국전력", "292.9원", "309.1원"),
              rowCell("GS 칼텍스", "279원", "279원"),
              rowCell("제주전기자동차서비스", "280원", "280원"),
              rowCell("한국전기차충전서비스", "255.7원", "290원"),
              rowCell("에스트래픽", "292.9원", "309.1원"),
              rowCell("현대오일뱅크", "292.9원", "309.1원"),
              rowCell("SK에너지", "255원", "255원"),
              rowCell("차지비", "279원", "279원"),
              rowCell("에버온", "292.9원", "309.1원"),
              rowCell("제주도청", "290원", "290원"),
            ],
          ),
        ],
      ),
    ),
  );
}

DataRow rowCell(String manage, String underPrice, String upperPrice) {
  return DataRow(
    cells: [
      DataCell(Text(
        manage,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 10.0,
        ),
      )),
      DataCell(Text(
        underPrice,
        style: TextStyle(fontSize: 9.0),
      )),
      DataCell(Text(
        upperPrice,
        style: TextStyle(fontSize: 9.0),
      )),
    ],
  );
}

Widget chargeType() {
  return Padding(
    padding: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "DC콤보",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "DC차데모",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "AC 3상",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "완속",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "슈퍼차지",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 16),
        Text(
          "데스티네이션",
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ],
    ),
  );
}
