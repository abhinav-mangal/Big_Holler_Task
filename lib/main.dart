import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
// ignore: unused_import
import 'dart:ui' as ui;

import 'imports.dart';

void main() => runApp(
      DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    return MultiProvider(
      builder: DevicePreview.appBuilder,
      providers: [
        StreamProvider<ConnectionType>.value(
          value: ConnectivityService().connectivityController.stream,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: app_name,
        theme:
            ThemeData(primarySwatch: Colors.amber, primaryColor: PrimaryColor),
        home: SplashScreen(),
        routes: <String, WidgetBuilder>{
          P_LocationInfo: (_) => LocationInfo(),
          P_ListLocations: (_) => ListLocations(),
          P_MenuScreen: (_) => MenuScreen(),
          P_LoyaltyScreen: (_) => LoyaltyScreen(),
          P_OpenLink: (_) => OpenLink(),
        },
      ),
    );
  }
}
