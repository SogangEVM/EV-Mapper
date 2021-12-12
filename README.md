# EV Mapper
## Electric Vehicle Mapper

------------------------------------------
Flutter Guard Management Application for Stationary Guard and Patrolling Guard. </br>
Using Rest API, Google Maps, etc. </br>


## Getting Started

There's nothing for you to do!

## How to Use 

1. Using packages(Specified version)
~~~yaml
dependencies:
  flutter:
    sdk: flutter
  naver_map_plugin:
    git: https://github.com/LBSTECH/naver_map_plugin.git
  http: ^0.13.3
  modal_bottom_sheet: ^2.0.0
  store_redirect: ^2.0.0
  location: ^4.3.0
  xml: ^5.3.1
  flutter_easyloading: ^3.0.3
~~~
</br>

2. Dependencies (At android/app/src/main/AndroidManifest.xml above activity)
~~~xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.donghyuk.EVMap">
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <uses-permission android:name="android.permission.INTERNET"/>
</manifest>
~~~
</br>

3. install (At terminal)
~~~Linux
flutter pub get
~~~
or save file at your IDE. (It will automatically install it)
</br>


### Libraries & Tools Used
* [naver_map_plugin](https://github.com/LBSTECH/naver_map_plugin.git)
* [http](https://pub.dev/packages/http)
* [modal_bottom_sheet](https://pub.dev/packages/modal_bottom_sheet)
* [store_redirect](https://pub.dev/packages/store_redirect)
* [location](https://pub.dev/packages/location)
* [xml](https://pub.dev/packages/xml)
* [flutter_easyloading](https://pub.dev/packages/easy_loading)

### Folder Structure
Here is the core folder structure which flutter provides.

```
flutter-app/
|- android
|- build
|- images
|- ios
|- lib
```

Here is the folder structure we have been using in this project

```
lib/
|- src
    |- components/
    |- models/
    |- screens/
    |- services/
|- generated_plugin_registrant.dart
|- main.dart/
```

Now, lets dive into the lib folder which has the main code for the application.

```
1- components - Directory for frequently used Widget, Dialogs, Fonts etc.
2- models - Model class for store data. (Guard, Route, Station etc)
3- screens - All of screens(UI) is in here.
4- services - Functions, services.
8- main.dart - This is the starting point of the application. 
All the navigations and viewmodels are defined in this file .
```

### components

This directory contains a frequently used Widget, Dialogs, Fonts etc.

```
components/
|- color_code.dart
|- dialogs.dart
|- material_themes.dart
```

### models

All the business logic of application will go into this directory, it represents the data layer of application. Since each layer exists independently, that makes it easier to unit test. 

```
models/
|- my_location.dart
|- paths.dart
|- station.dart
|- user.dart
```

### screens

This directory contains all the UI of application. Each screen is located in a separate folder making it easy to combine group of files related to that particular screen. 

```
screens/
|- evm_help
   |- evm_help.dart
|- evm_map
   |- main_map.dart
   |- searching_bar.dart
   |- station_info.dart
|- evm_user
   |- user_page.dart
```

### services

Contains the functions, services for REST API(Kakao navi, Tmap..)

```
services/
|- direction5.dart
|- fetch_path.dart
|- fetch_station.dart
|- invoke_navigation.dart
```

### Main

This is the starting point of the application. All the navigations and viewmodels are defined in this file.

```dart
import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/components/material_themes.dart';
import 'package:electric_vehicle_mapper/src/screens/evm_map/main_map.dart';
import 'package:electric_vehicle_mapper/src/screens/evm_help/evm_help.dart';
import 'package:electric_vehicle_mapper/src/screens/evm_user/user_page.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

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
      darkTheme: materialDarkTheme(),
      home: MainPage(),
      builder: EasyLoading.init(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _screenIndex = 0;
  final List<Widget> _screens = [EvmMap(), EvmHelp(), ProfilePage()];

  @override
  void initState() {
    super.initState();
    darkMode =
        SchedulerBinding.instance?.window.platformBrightness == Brightness.dark;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: BottomNavigationBar(
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
```
## Demo

### Launch
![app demo1](https://user-images.githubusercontent.com/65856090/145717079-44f4ed87-e3e4-4d3e-aa9f-20c9c92e0c90.gif)

### Menu
![app demo2](https://user-images.githubusercontent.com/65856090/145717081-eccb74ca-1e03-4f72-afc5-d5818102ba82.gif)

### Show Station Info
![app demo3](https://user-images.githubusercontent.com/65856090/145717085-d461e709-b149-41ee-baeb-f7cfd97023ca.gif)

### Move to Navigation Application
![app demo4](https://user-images.githubusercontent.com/65856090/145717090-92306ba1-8ead-4b0e-a27a-b1ed87891463.gif)


## Wiki

Checkout [Sogang wiki](http://cscp2.sogang.ac.kr/CSE4187/index.php/EVM(Electric_Vehicle_Mapper)) for more information about this project
