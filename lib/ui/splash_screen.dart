import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as p;
import '../imports.dart';
import 'dart:io';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  final _globalScaffoldKey = GlobalKey<ScaffoldState>();
  String _version, loadingMessage = "Loading restaurant information...";
  Color appColor = PrimaryColor;
  ConnectionType network;
  Directory dirToSave;
  Metadata metadata;

  ///This is for handling asssets and download locally
  var list = [];
  var jsonObjUrls = {};
  var storedJsonObjUrls;

  User user;
  UserLogin userLogin;
  bool isLoginSuccessfully = false;
  ApiService apiService = ApiService();

  _getAppPath() async {
    Directory dirToSaveData = await getApplicationDocumentsDirectory();
    setState(() {
      dirToSave = dirToSaveData;
    });
  }

  void _navigateToDashboard(BuildContext context) async {
    var metas = await SPHelper.getMetadata();
    if (metas.list.length == 1) {
      Navigator.of(context).pushNamedAndRemoveUntil(
        P_LocationInfo,
        (Route<dynamic> route) => false,
        arguments: Param(
          metas.list[0],
          metas,
          metas.list[0].locations.list[0],
          dir: dirToSave,
        ),
      );
    } else {
      SPHelper.getLocationMetadat().then((meta) async {
        if (meta != null) {
          SPHelper.setLocationMetadata(meta);
          Navigator.of(context).pushNamedAndRemoveUntil(
            P_LocationInfo,
            (Route<dynamic> route) => false,
            arguments: Param(
              meta,
              metas,
              meta.locations.list[0],
              dir: dirToSave,
            ),
          );
        } else {
          Position p = Position(latitude: 0, longitude: 0);
          try {
            await Geolocator.isLocationServiceEnabled();
            p = await Geolocator.getCurrentPosition();
            for (var loc in metadata.locations.list)
              loc.distance = Geolocator.distanceBetween(
                  p.latitude, p.longitude, loc.latitude, loc.longitude);
          } catch (e) {
            for (var loc in metadata.locations.list)
              loc.distance =
                  Geolocator.distanceBetween(0, 0, loc.latitude, loc.longitude);
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            P_ListLocations,
            (Route<dynamic> route) => false,
            arguments: Param(
              metas.list[0],
              metas,
              metas.list[0].locations.list[0],
              position: p,
              dir: dirToSave,
            ),
          );
        }
      }).catchError((e) {
        if (context != null)
          alertActionDialog(
            context,
            appColor,
            msg_something_went_wrong,
            t_retry,
            () {
              Navigator.of(context).pop();
              fetchMetadata();
            },
          );
      });
    }
  }

  bool checkImageExist(imageUrl, lastUpdated) {
    String fileName;
    File localFile;

    //Check the urls
    if (imageUrl == null && imageUrl.isEmpty) return false;

    fileName = p.basename(imageUrl);
    localFile = File("${dirToSave.path}/$fileName");

    bool isExist = localFile.existsSync();
    bool isImageUpdated = false;
    jsonObjUrls[fileName] = {"url": imageUrl, "lastUpdated": lastUpdated};

    ///Check the image time stamp they are updated or not
    if (storedJsonObjUrls != null && storedJsonObjUrls[fileName] != null) {
      if (storedJsonObjUrls[fileName]["lastUpdated"] != lastUpdated) {
        isImageUpdated = true;
      }
    }

    if (isExist)
      return !isImageUpdated;
    else
      return false;
  }

  downloadAssetsLocally(List<Metadata> locationsMetadata) async {
    SPHelper.getImagesData().then((data) {
      storedJsonObjUrls = data;
    });
    list = [];
    for (var metadata in locationsMetadata) {
      var loc = metadata.locations.list[0];

      ///Check fot the gallery Images
      for (var imageUrlData in loc.gallery.list) {
        var isDownload =
            checkImageExist(imageUrlData.path, imageUrlData.lastUpdated);
        if (!isDownload) list.add(imageUrlData.path);
      }

      ///Check fot the menu images
      for (var menu in loc.menus.list) {
        for (var image in menu.urls.list) {
          var isDownload = checkImageExist(image.path, image.lastUpdated);
          if (!isDownload) list.add(image.path);
        }
      }
    }

    /// Download all the images
    for (var url in list) {
      try {
        String fileName = p.basename(url);
        var req = await http.Client().get(Uri.parse(url));
        var file = File("${dirToSave.path}/$fileName");
        await file.writeAsBytes(req.bodyBytes);
      } catch (error) {
        print(error);
      }
    }
    SPHelper.setImagesData(jsonObjUrls).then((onValue) {});
  }

  void fetchMetadata({bool alreadyLogin = false}) async {
    ///Check network state
    ConnectivityService connectivityService = ConnectivityService();
    network = await connectivityService.getNetworkStatus();
    if (network != ConnectionType.offline) {
      setState(() {
        loadingMessage = 'Loading restaurant information...';
      });
      ApiService apiService = ApiService();
      Login login = Login(c_username, c_password);
      var response = await apiService.loginUser(context, login);
      if (response.success) {
        var token = response.response[j_token];
        SPHelper.setAppToken(token);

        //Pull all the websites
        var websites = (response.response[j_websites]).split(",");
        List<Metadata> locationsMetadata = [];
        var spLocMeta = await SPHelper.getLocationMetadat();
        for (var v in websites) {
          try {
            ApiResponse data = await apiService.getWebsiteDetails(context, v);
            if (data.success) {
              var meta = Metadata.fromJson(data.response);
              metadata = meta;
              setState(() {
                loadingMessage = "Loading information for ${meta.name}...";
              });
              locationsMetadata.add(meta);
              if (spLocMeta != null && spLocMeta.id == meta.id)
                SPHelper.setLocationMetadata(meta);
            }
          } catch (e) {
            print(e);
          }
        }

        downloadAssetsLocally(locationsMetadata);
        setState(() {});
        if (locationsMetadata.length == 0)
          alertActionDialog(
            context,
            appColor,
            "No Locations found",
            t_retry,
            () {
              Navigator.of(context).pop();
              fetchMetadata();
            },
          );
        else {
          SPHelper.setMetaData(Metadatas(locationsMetadata)).then((onValue) {
            _navigateToDashboard(context);
          });
        }
      } else
        alertActionDialog(
          context,
          appColor,
          msg_something_went_wrong,
          t_retry,
          () {
            Navigator.of(context).pop();
            fetchMetadata();
          },
        );
    } else
      alertActionDialog(
        context,
        appColor,
        msg_internet_connection,
        t_retry,
        () {
          Navigator.of(context).pop();
          fetchMetadata();
        },
      );
  }

  void handlePushNotification() {
    firebaseMessaging.configure(
      onLaunch: (Map<String, dynamic> msg) async {
        print(msg);
      },
      onResume: (Map<String, dynamic> msg) async {
        print(msg);
      },
      onMessage: (Map<String, dynamic> msg) async {
        _showNotification(
            msg['aps']['alert']['title'], msg['aps']['alert']['body']);
      },
    );
  }

  Future<void> _showNotification(String title, body) async {
    print('inside show notificaiton');
  }

  @override
  void initState() {
    firebaseMessaging.requestNotificationPermissions(
      const IosNotificationSettings(sound: true, alert: true, badge: true),
    );
    firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print('IOS Setting Registed');
    });
    firebaseMessaging.getToken().then((token) {
      SPHelper.setNotificationToken(token);
    });
    handlePushNotification();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        _version = "V ${packageInfo.version}";
      });
    });
    super.initState();
    _getAppPath();
    SPHelper.getAppToken().then((token) {
      if (token == null || (token != null && token.isEmpty)) {
        fetchMetadata(alreadyLogin: false);
      } else
        fetchMetadata(alreadyLogin: true);
    });
  }

  pageView(String appName, {String clrString = '#FFFFFF'}) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 30),
              // Container(
              //   height: 20,
              //   width: 30,
              // ),
              AspectRatio(
                child: FittedBox(
                    child: LocTitle(
                  appName,
                  Colors.white,
                )),
                aspectRatio: 11 / 2,
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    AspectRatio(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          msg_bh_splash_text,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      aspectRatio: 14 / 2,
                    ),
                    const SizedBox(height: 20),
                    network != ConnectionType.offline
                        ? AspectRatio(
                            child: FittedBox(
                              child: CustomLoader(
                                text: loadingMessage,
                                colorString: clrString,
                              ),
                            ),
                            aspectRatio: 16 / 2,
                          )
                        : SizedBox(),
                    const SizedBox(height: 5),
                    AspectRatio(
                      child: FittedBox(child: VersionCode(_version)),
                      aspectRatio: 40 / 2,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    double _h = MediaQuery.of(context).textScaleFactor;
    var b = MediaQuery.of(context).platformBrightness;
    network = Provider.of<ConnectionType>(context);

    if (metadata != null)
      appColor = Helper.getColorFromHex(metadata.primaryColor);
    print(_h);
    print(b);

    return Scaffold(
      key: _globalScaffoldKey,
      body: Container(
        padding: pagePadding,
        decoration: BoxDecoration(
          color: bgSplashColor,
          image: DecorationImage(
            //alignment: ,
            fit: BoxFit.scaleDown,
            image: AssetImage(
              img_splash,
            ),
          ),
        ),
        // height: 2000,
        // width: 2000,
        child: metadata == null
            ? pageView(app_name)
            : pageView(metadata.name, clrString: metadata.primaryColor),
      ),
    );
  }
}
