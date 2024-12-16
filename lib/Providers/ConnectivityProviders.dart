import 'dart:async';
import 'dart:developer' as developer;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConnectivityProviders with ChangeNotifier {
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  String isDeviceConnected = "ConnectivityResult.none";

  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();


  static final ConnectivityProviders _instance = ConnectivityProviders._internal();
  factory ConnectivityProviders() {
    return _instance;
  }
  ConnectivityProviders._internal();

  // Initialize the connectivity service and start listening to changes
  Future<void> initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }
    _updateConnectionStatus(result);

    // Subscribe to connectivity changes
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    _connectionStatus = result;
    for (int i = 0; i < _connectionStatus.length; i++) {
      isDeviceConnected = _connectionStatus[i].toString();
      notifyListeners(); // Notify listeners when the connection status changes
      print("isDeviceConnected: $isDeviceConnected");
    }
    print('Connectivity changed: $_connectionStatus');
    notifyListeners(); // Notify listeners when the connection status changes
  }

  // Dispose the subscription when no longer needed
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }


  List<ConnectivityResult> getConnectionStatus() {
    return _connectionStatus;
  }
}
