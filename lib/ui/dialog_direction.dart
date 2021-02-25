import 'dart:io';
import '../imports.dart';

class DirectionDialog extends StatelessWidget {
  final Location location;
  final Color appColor;
  DirectionDialog(this.location, this.appColor);

  dialogContent(BuildContext context) {
    openMap(MapType mapType) async {
      if (Platform.isIOS) {
        // This link is in the apple format so we are keeping standart for iOS
        var mapLink =
            "https://maps.apple.com/?q=${location.latitude},${location.longitude}";
        switch (mapType) {
          case MapType.Apple:
            await launch(mapLink);
            break;

          case MapType.Google:
            var gLink =
                "comgooglemaps:\/\/?saddr=${location.latitude},${location.longitude}&directionsmode=driving";
            var isOpen = await canLaunch("comgooglemaps://");
            if (isOpen)
              await launch(gLink);
            else
              await launch(mapLink);
            break;

          case MapType.Waze:
            var wLink =
                "waze:\/\/?ll=${location.latitude},${location.longitude}&navigate=yes";
            var isOpen = await canLaunch("waze://");
            if (isOpen)
              await launch(wLink);
            else
              await launch(mapLink);
            break;

          default:
            launch(mapLink);
        }
      } else if (Platform.isAndroid) {
        // This link is in the google format so we are keeping standart for Android
        var mapLink =
            "https://maps.google.com/?q=${location.latitude},${location.longitude}&dir_action=navigate";
        switch (mapType) {
          case MapType.Google:
            await launch(mapLink);
            break;

          case MapType.Waze:
            var wLink =
                "https://waze.com/ul?ll=${location.latitude},${location.longitude}&navigate=yes";
            var isOpen = await canLaunch("waze://");
            if (isOpen)
              await launch(wLink);
            else
              await launch(mapLink);
            break;

          default:
            launch(mapLink);
        }
      } else {
        var gUrl =
            "https://maps.google.com/?q=${location.latitude},${location.longitude}";
        if (await canLaunch(gUrl)) {
          await launch(gUrl);
        } else {
          throw 'Could not open the map.';
        }
      }
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[CloseBtn()],
          ),
          AppText(
            msg_direction_option,
            align: TextAlign.center,
            size: 24,
            bold: true,
            color: Colors.black,
          ),
          const SizedBox(height: 30),
          Container(
            height: 76,
            width: 76,
            decoration: BoxDecoration(shape: BoxShape.circle, color: appColor),
            child: Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 48,
            ),
          ),
          const SizedBox(height: 30),
          AppText(
            'Select the option you prefer?',
            color: Colors.black,
          ),
          const SizedBox(height: 20),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 30),
            height: 1,
            color: Colors.black12,
          ),
          Platform.isIOS
              ? InkWell(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: AppText('Apple',
                            color: appColor, bold: true, size: 18),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 30),
                        height: 1,
                        color: Colors.black12,
                      ),
                    ],
                  ),
                  onTap: () => openMap(MapType.Apple),
                )
              : SizedBox(),
          InkWell(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: AppText(
                    'Google',
                    color: appColor,
                    bold: true,
                    size: 18,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 1,
                  color: Colors.black12,
                )
              ],
            ),
            onTap: () => openMap(MapType.Google),
          ),
          InkWell(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  child: AppText(
                    'Waze',
                    color: appColor,
                    bold: true,
                    size: 18,
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 1,
                  color: Colors.black12,
                ),
              ],
            ),
            onTap: () => openMap(MapType.Waze),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
  }
}
