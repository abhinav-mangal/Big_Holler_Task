import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../imports.dart';

import 'dart:io';

class Utils {
  launchURL(BuildContext context, Color appColor, String url) async {
    if (url != null && url.isNotEmpty && await canLaunch(url)) {
      await launch(url, forceSafariVC: false);
    } else {
      alertDialog(context, appColor, 'Could not open this link');
    }
  }

  checkForUpdate(BuildContext context) async {
    try {
      await Firebase.initializeApp();
      var packageInfo = await PackageInfo.fromPlatform();
      int currCode = int.parse(packageInfo.buildNumber);
      var runningOS = Platform.isIOS ? C_IOS : C_ANDROID;
      var data = await FirebaseFirestore.instance
          .collection(app_name)
          .doc(runningOS)
          .get();
      var code = data[C_CODE];
      var mandatory = data[C_MANDATORY];
      var appLink = data[C_APP_LINK];
      if (currCode < code) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext contest) {
            return Platform.isIOS
                ? CupertinoAlertDialog(
                    title: appText(
                      'APP UPDATE',
                      color: Colors.black,
                      isBold: true,
                    ),
                    content: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: appText(
                        'New version of app is available',
                        color: primaryTextColor,
                      ),
                    ),
                    actions: mandatory
                        ? <Widget>[
                            FlatButton(
                              child: appText(
                                t_update.toUpperCase(),
                                color: Colors.green,
                                isBold: true,
                              ),
                              onPressed: () =>
                                  launchURL(context, Colors.green, appLink),
                            ),
                          ]
                        : <Widget>[
                            FlatButton(
                              child: appText(
                                t_skip.toUpperCase(),
                                color: primaryTextColor,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            FlatButton(
                              child: appText(
                                t_update.toUpperCase(),
                                color: Colors.green,
                                isBold: true,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                launchURL(context, Colors.green, appLink);
                              },
                            ),
                          ],
                  )
                : AlertDialog(
                    title: appText(
                      'APP UPDATE',
                      color: Colors.black,
                      isBold: true,
                    ),
                    content: appText(
                      'New version of app is available',
                      color: primaryTextColor,
                    ),
                    actions: mandatory
                        ? <Widget>[
                            FlatButton(
                              child: appText(
                                t_update.toUpperCase(),
                                color: Colors.green,
                                isBold: true,
                              ),
                              onPressed: () =>
                                  launchURL(context, Colors.green, appLink),
                            ),
                          ]
                        : <Widget>[
                            FlatButton(
                              child: appText(
                                t_skip.toUpperCase(),
                                color: primaryTextColor,
                              ),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                            FlatButton(
                              child: appText(
                                t_update.toUpperCase(),
                                color: Colors.green,
                                isBold: true,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                launchURL(context, Colors.green, appLink);
                              },
                            ),
                          ],
                  );
          },
        );
      }
    } catch (e) {
      return;
    }
  }
}

final utils = Utils();
