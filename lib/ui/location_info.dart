import 'package:path/path.dart' as p;
import '../imports.dart';
import 'dart:io';
import 'dart:ui';

class LocationInfo extends StatefulWidget {
  @override
  _LocationInfoState createState() => _LocationInfoState();
}

class _LocationInfoState extends State<LocationInfo> {
  bool rating = false, isDirectionShow = false, multiLocs = true;
  ApiService apiService = ApiService();
  double totalRating = 0, rate = 3.0;
  bool isLoginSuccessfully = false;
  Color appColor = PrimaryColor;
  ConnectionType network;
  int galleryImgNo = 0;
  Metadatas metadatas;
  UserLogin userLogin;
  Directory dirToSave;
  Metadata metadata;
  Location location;
  MenuTabs menuTabs;
  User user;

  @override
  void initState() {
    _getAppPath();
    _loadUser();
    utils.checkForUpdate(context);
    super.initState();
  }

  _getAppPath() async {
    Directory dirToSaveData = await getApplicationDocumentsDirectory();
    setState(() {
      dirToSave = dirToSaveData;
    });
  }

  _loadUser() async {
    userLogin = await SPHelper.getUserLoginData();
    if (userLogin != null && userLogin.username.isNotEmpty) {
      var status = await apiService.loginEndUser(context, userLogin);
      if (status.success == true) {
        user = User.fromJson(status.response);
        SPHelper.setUserData(user).then((onValue) {
          user = User.fromJson(status.response);
          isLoginSuccessfully = true;
        });
      } else {
        isLoginSuccessfully = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    network = Provider.of<ConnectionType>(context);
    Param param = ModalRoute.of(context).settings.arguments;
    metadatas = param.metadatas;
    metadata = param.metadata;
    location = param.location;
    dirToSave = param.dir;

    appColor = Helper.getColorFromHex(metadata.primaryColor);
    isDirectionShow = location.latitude != null && location.longitude != null;
    rating = location.isRatingAvailable;
    totalRating = location.totalRating;
    rate = location.avgRating;
    multiLocs = metadatas.list.length > 1;

    var h = MediaQuery.of(context).size.height / 2.5;
    var w = MediaQuery.of(context).size.width;
    var bh = rating ? 150.0 : 75.0;
    var bch = h - bh / 2;

    var fit;
    if (h > w) {
      fit = BoxFit.fitHeight;
    } else {
      fit = BoxFit.fitWidth;
    }

    redirectPage(User userData) {
      Navigator.pop(context);
      SPHelper.setUserData(userData).then((onValue) {
        this.user = userData;
        isLoginSuccessfully = true;
        Navigator.pushNamed(
          context,
          P_LoyaltyScreen,
          arguments: Param(
            metadata,
            metadatas,
            location,
            user: this.user,
          ),
        );
      });
    }

    goLoyaltyPage() {
      if (!isLoginSuccessfully) {
        if (network == ConnectionType.offline) {
          alertDialog(context, appColor, msg_internet_connection);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) => LoginDialog(
                metadata: metadata,
                location: location,
                userData: (user) {
                  redirectPage(user);
                }),
          );
        }
      } else {
        Navigator.pushNamed(
          context,
          P_LoyaltyScreen,
          arguments: Param(
            metadata,
            metadatas,
            location,
            user: this.user,
          ),
        );
      }
    }

    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Column(
          children: <Widget>[
            Stack(
              fit: StackFit.passthrough,
              children: <Widget>[
                CarouselSlider(
                  options: CarouselOptions(
                    height: h,
                    autoPlay: location.gallery.list.length > 1,
                    autoPlayInterval: Duration(seconds: 5),
                    viewportFraction: 1.0,
                  ),
                  items: location.gallery.list.length > 0
                      ? location.gallery.list.map((i) {
                          String fileName, assetFileName;
                          File localFile;
                          bool isExist = false;
                          if (i.path != null && i.path.isNotEmpty) {
                            fileName = p.basename(i.path);
                            localFile = File("${dirToSave.path}/$fileName");
                            isExist = localFile.existsSync();
                          }

                          ///This works when the image downloaded are not available
                          ///and to avoide if the gallery has more than three images
                          galleryImgNo++;
                          if (!isExist) {
                            if (galleryImgNo > 3)
                              galleryImgNo = galleryImgNo - 3;

                            var assetGallery = [
                              img_gallery_one,
                              img_gallery_two,
                              img_gallery_three
                            ];
                            switch (galleryImgNo) {
                              case 1:
                                assetFileName = img_gallery_one;
                                break;
                              case 2:
                                assetFileName = img_gallery_two;
                                break;
                              case 3:
                                assetFileName = img_gallery_three;
                                break;
                              default:
                                assetFileName = (assetGallery..shuffle()).first;
                            }
                          }
                          return (i.path != null &&
                                  i.path.isNotEmpty &&
                                  isExist)
                              ? ExtendedImage.file(
                                  localFile,
                                  height: h,
                                  width: w,
                                  fit: fit,
                                  enableLoadState: true,
                                  loadStateChanged: (ExtendedImageState state) {
                                    switch (state.extendedImageLoadState) {
                                      case LoadState.failed:
                                        return ImgErrorPlaceholder(fit: fit);
                                        break;
                                      case LoadState.completed:
                                      case LoadState.loading:
                                      default:
                                        return ExtendedRawImage(
                                          image: state.extendedImageInfo?.image,
                                          width: w,
                                          height: h,
                                          fit: fit,
                                        );
                                        break;
                                    }
                                  },
                                )
                              : Image.asset(
                                  assetFileName,
                                  height: h,
                                  width: w,
                                  fit: fit,
                                );
                        }).toList()
                      : [
                          Image.asset(
                            img_gallery_one,
                            height: h,
                            width: w,
                            fit: fit,
                          ),
                          Image.asset(
                            img_gallery_two,
                            height: h,
                            width: w,
                            fit: fit,
                          ),
                          Image.asset(
                            img_gallery_three,
                            height: h,
                            width: w,
                            fit: fit,
                          )
                        ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(height: bch),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      height: bh,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20.0,
                          )
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: bh / 2 - 0.5,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 0),
                                    child: TimeNRatings(
                                      location: location,
                                      ratingAlignment: MainAxisAlignment.center,
                                      appColor: appColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 1, color: Colors.black12),
                            Container(
                              height: bh / 2 - 0.5,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: AppText(location.address,
                                    align: TextAlign.center),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                InkWell(
                  child: LocTitle(
                    location.name,
                    appColor,
                    multiLocs: multiLocs,
                  ),
                  onTap: multiLocs
                      ? () async {
                          try {
                            await Geolocator.isLocationServiceEnabled();
                            var p = await Geolocator.getCurrentPosition();
                            for (var loc in metadata.locations.list)
                              loc.distance = Geolocator.distanceBetween(
                                p.latitude,
                                p.longitude,
                                loc.latitude,
                                loc.longitude,
                              );
                          } catch (e) {
                            for (var loc in metadata.locations.list)
                              loc.distance = Geolocator.distanceBetween(
                                  0, 0, loc.latitude, loc.longitude);
                          }
                          Navigator.pushNamed(context, P_ListLocations,
                              arguments: param);
                        }
                      : null,
                )
              ],
            ),
            Padding(
              padding: pagePadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 10),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: InkWell(
                      child: (metadata.description != null &&
                              metadata.description.isNotEmpty)
                          ? Text(
                              metadata.description,
                              style: TextStyle(
                                  color: primaryTextColor, fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            )
                          : SizedBox(),
                      onTap: () => alertDialog(
                        context,
                        appColor,
                        metadata.description,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: Colors.black12,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      if (location.menuTabs != null)
                        InkWell(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.restaurant_menu,
                                color: appColor,
                              ),
                              const SizedBox(width: 10),
                              AppText(t_menu, size: 14, bold: true),
                            ],
                          ),
                          onTap: () => Navigator.pushNamed(
                            context,
                            P_MenuScreen,
                            arguments: Param(
                              metadata,
                              metadatas,
                              location,
                              dir: dirToSave,
                            ),
                          ),
                        ),
                      if (location.menuTabs != null &&
                          (isDirectionShow || metadata.inLoyaltyProgram))
                        Container(color: Colors.black12, width: 1, height: 20),
                      isDirectionShow
                          ? InkWell(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Icon(
                                    Icons.directions_car,
                                    color: appColor,
                                  ),
                                  const SizedBox(width: 10),
                                  AppText(t_directions, size: 14, bold: true),
                                ],
                              ),
                              onTap: () => showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    DirectionDialog(location, appColor),
                              ),
                            )
                          : SizedBox(),
                      if (metadata.inLoyaltyProgram &&
                          (isDirectionShow || location.menuTabs != null))
                        Container(color: Colors.black12, width: 1, height: 20),
                      if (metadata.inLoyaltyProgram)
                        InkWell(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.loyalty,
                                  color: appColor,
                                ),
                                const SizedBox(width: 10),
                                AppText(t_loyalty, size: 14, bold: true),
                              ],
                            ),
                            onTap: () => goLoyaltyPage()),
                      if (location.links.list.length > 0)
                        InkWell(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.more_vert,
                                color: appColor,
                              ),
                            ],
                          ),
                          onTap: () => showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                MenuDialog(location, appColor),
                          ),
                        )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 1,
                    color: Colors.black12,
                  ),
                  const SizedBox(height: 20),
                  OrderButton(context, metadata, appColor),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
