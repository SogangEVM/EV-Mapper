import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/components/material_themes.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;
import 'package:electric_vehicle_mapper/src/screens/evm_map.dart';
import 'package:electric_vehicle_mapper/src/screens/evm_help.dart';
import 'package:kakao_flutter_sdk/navi.dart';

String clientId = '0i7ovndb4a';
String clientSecret = 'VIYmIJ6cjEk7DqhHNLDOdOVS8hKSAQElCQDTFc3O';

void main() {
  runApp(ElectricVehicleMapper());
}

class ElectricVehicleMapper extends StatefulWidget {
  @override
  _ElectricVehicleMapperState createState() => _ElectricVehicleMapperState();
}

class _ElectricVehicleMapperState extends State<ElectricVehicleMapper> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: materialThemes(),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _screenIndex = 0;
  final List<Widget> _screens = [EvmMap(), EvmHelp(), EvmHelp()];

  @override
  void initState() {
    super.initState();
    KakaoContext.clientId = "4b9a4abdfc5d02f9b075402afb3d754e";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: evmColor.foregroundColor,
        selectedIconTheme: IconThemeData(
          size: 24.0,
        ),
        unselectedIconTheme: IconThemeData(
          size: 20.0,
        ),
        onTap: (int index) {
          setState(() {
            _screenIndex = index;
          });
        },
        currentIndex: _screenIndex,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.electric_car_outlined), label: '충전소 찾기'),
          BottomNavigationBarItem(
              icon: Icon(Icons.flash_on_outlined), label: '충전정보'),
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined), label: '내정보'),
        ],
      ),
      body: IndexedStack(
        index: _screenIndex,
        children: _screens,
      ),
    );
  }
}
