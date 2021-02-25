import 'dart:async';
import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  StreamController<ConnectionType> connectivityController =
      StreamController<ConnectionType>();

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult status) {
      var _connectionStatus = _networkStatus(status);
      connectivityController.add(_connectionStatus);
    });
  }

  getNetworkStatus() async {
    ConnectivityResult status = await Connectivity().checkConnectivity();
    var _connectionStatus = _networkStatus(status);
    return _connectionStatus;
  }

  ConnectionType _networkStatus(ConnectivityResult status) {
    switch (status) {
      case ConnectivityResult.mobile:
        return ConnectionType.mobileData;

      case ConnectivityResult.wifi:
        return ConnectionType.wifi;

      case ConnectivityResult.none:
      default:
        return ConnectionType.offline;
    }
  }
}

enum ConnectionType { wifi, mobileData, offline }
