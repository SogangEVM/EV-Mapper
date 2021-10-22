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
          flexibleSpace: SafeArea(
            child: Column(
              children: [
                TabBar(
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), // Creates border
                      color: evmColor.backgroundColor),
                  tabs: [
                    Container(
                      height: 50.0,
                      child: Center(
                        child: Text('충전요금'),
                      ),
                    ),
                    Text(
                      '충전기종류',
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: Image(image: AssetImage('images/EVfee.png')),
            ),
            Icon(Icons.directions_transit, size: 350),
          ],
        ),
      ),
    );
  }
}
