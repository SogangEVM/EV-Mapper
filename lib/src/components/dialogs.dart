import 'dart:io' show Platform;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:electric_vehicle_mapper/src/services/invoke_navigation.dart';

void selectNavigationDialog(BuildContext context) {
  showCupertinoDialog(
      barrierDismissible: true,
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          content: Row(
            children: [
              Column(
                children: [
                  TextButton(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: AssetImage('images/kakaonavi_icon.png'),
                        width: 90.0,
                        height: 90.0,
                      ),
                    ),
                    onPressed: () async {
                      await invokeKakaonavi(context, "서울마포 코오롱하늘채아파트 A단지",
                          37.5648202770, 126.9201570654);
                      //Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("카카오내비"),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  TextButton(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image(
                        image: AssetImage('images/tmap_icon.png'),
                        width: 90.0,
                        height: 90.0,
                      ),
                    ),
                    onPressed: () async {
                      await invokeTmap(context, "서울마포 코오롱하늘채아파트 A단지",
                          37.5648202770, 126.9201570654);
                      //Navigator.of(context).pop();
                    },
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Text("티맵"),
                ],
              ),
            ],
          ),
        );
      });
}

void showNotInstalledDialog(BuildContext context, bool result, String title,
    String content, String androidId, String iOSId) {
  Widget _titleMessage = Text(title,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0));

  Widget _contentMessage = Padding(
    padding: EdgeInsets.only(
      top: 10.0,
    ),
    child: Text(content),
  );

  Widget _confirmButton = TextButton(
    child: Text("확인"),
    onPressed: () async {
      // Navigator.of(context).pop();
      // Navigator.of(context).pop();
      await StoreRedirect.redirect(
        androidAppId: androidId,
        iOSAppId: iOSId,
      );
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    },
  );

  Widget _cancelButton = TextButton(
    child: Text("취소"),
    onPressed: () {
      Navigator.of(context).pop();
      Navigator.of(context).pop();
    },
  );

  if (!result)
    Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: _titleMessage,
                content: _contentMessage,
                actions: [
                  _cancelButton,
                  _confirmButton,
                ],
              );
            })
        : showCupertinoDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: _titleMessage,
                content: _contentMessage,
                actions: [
                  _cancelButton,
                  _confirmButton,
                ],
              );
            });
}
