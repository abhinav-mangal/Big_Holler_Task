import '../imports.dart';
import 'dart:io';

class ListLocations extends StatefulWidget {
  @override
  _ListLocationsState createState() => _ListLocationsState();
}

class _ListLocationsState extends State<ListLocations> {
  Metadatas metas;
  Metadata metadata;
  Directory dirToSave;
  Position currentLocation;

  setDefaultLocation(Metadata meta, Directory dirToSave) {
    SPHelper.setLocationMetadata(meta).then((v) {
      Navigator.pushReplacementNamed(
        context,
        P_LocationInfo,
        arguments: Param(meta, metas, meta.locations.list[0], dir: dirToSave),
      );
    }).catchError((e) {});
  }

  locationCard(Metadata m, int index) {
    Location location = m.locations.list[0];
    return Card(
      elevation: 2.0,
      child: InkWell(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // (location.locationImage != null ||
              //         location.locationImage.isNotEmpty)
              //     ? CachedNetworkImage(
              //         imageUrl: location.locationImage,
              //         width: MediaQuery.of(context).size.width,
              //         height: 100,
              //         fit: BoxFit.cover,
              //         errorWidget: (context, url, error) => ImgErrorPlaceholder(),
              //       )
              //     : Image.asset(
              //         img_logo,
              //         width: MediaQuery.of(context).size.width,
              //         height: 100,
              //         fit: BoxFit.cover,
              //       ),
              // const SizedBox(height: 10),
              AppText(m.name, color: PrimaryColor, size: 16, bold: true),
              // const SizedBox(height: 10),
              TimeNRatings(
                location: location,
                spacing: 10,
                ratingAlignment: MainAxisAlignment.start,
                appColor: Helper.getColorFromHex(metadata.primaryColor),
                clickable: false,
                showRatings: false,
              ),
              const SizedBox(height: 10),
              AppText(location.address, size: 16),
            ],
          ),
        ),
        onTap: () => setDefaultLocation(m, dirToSave),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Param param = ModalRoute.of(context).settings.arguments;
    metadata = param.metadata;
    metas = param.metadatas;
    currentLocation = param.position;
    dirToSave = param.dir;

    var isLocationDistanceNull = false;
    for (var m in metas.list) {
      var loc = m.locations.list[0];
      if (loc.distance == null) {
        isLocationDistanceNull = true;
        break;
      }
    }

    if (!isLocationDistanceNull)
      metas.list.sort(
          (a, b) => a.distance != null ? a.distance.compareTo(b.distance) : 0);
    int locCount = metas.list.length;

    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: pagePadding,
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              (metadata.logo != null && metadata.logo.isNotEmpty)
                  ? CachedNetworkImage(
                      height: 100,
                      imageUrl: metadata.logo,
                      errorWidget: (context, url, error) =>
                          ImgErrorPlaceholder(),
                    )
                  : Image.asset(
                      img_logo,
                      width: 100,
                      height: 100,
                    ),
              const SizedBox(height: 10),
              AppText("Select Location ($locCount)", bold: true),
              Expanded(
                child: metas != null
                    ? ListView.builder(
                        itemCount: metas.list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return locationCard(metas.list[index], index);
                        },
                      )
                    : CustomLoader(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
