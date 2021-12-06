import 'package:flutter/material.dart';
import 'package:electric_vehicle_mapper/src/models/user.dart';
import 'package:electric_vehicle_mapper/src/components/color_code.dart'
    as evmColor;

final user = User(name: "정동혁", email: "jted0537@gmail.com");

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    // final user = UserPreferences.myUser;

    return Scaffold(
      // appBar: buildAppBar(context),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
        child: ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Center(
              child: CircleAvatar(
                radius: 60.0,
                backgroundColor: evmColor.foregroundColor,
                child: CircleAvatar(
                  backgroundImage: AssetImage('images/openmouse.png'),
                  radius: 58.5,
                ),
              ),
            ),
            SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            // Center(child: buildUpgradeButton()),
            const SizedBox(height: 24),
            //NumbersWidget(),
            const SizedBox(height: 30),
            buildAbout(user),
          ],
        ),
      ),
    );
  }

  Widget buildName(User user) => Column(
        children: [
          Text(
            user.name,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 4),
          Text(
            user.email,
            style: TextStyle(color: Colors.grey),
          )
        ],
      );

  Widget buildAbout(User user) => Container(
        // decoration: BoxDecoration(border: Border(top: BorderSide.),),
        padding: EdgeInsets.symmetric(horizontal: 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "마이페이지",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 3.0,
              color: evmColor.foregroundColor,
            ),
            SizedBox(height: 16),
            Text(
              "즐겨찾기",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "내가쓴글 보기",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "충전소 제보내역",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 40),
            Text(
              "커뮤니티",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Container(
              height: 3.0,
              color: evmColor.foregroundColor,
            ),
            SizedBox(height: 16),
            Text(
              "EV Map 공지사항",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Text(
              "자유게시판",
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ],
        ),
      );
}
