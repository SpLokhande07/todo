import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ConnectionHelper {
  final BuildContext context;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool? previousResult;

  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();
  Stream<bool> get connectionStream => _connectionController.stream;

  ConnectionHelper(this.context);

  void initialize() {
    _subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _showToast(connectionChecker(result));
      _connectionController.add(connectionChecker(result));
    });
  }

  void _showToast(bool result) {
    if (result != previousResult && previousResult != null) {
      if (!result) {
        Fluttertoast.showToast(
          msg: 'You have lost internet connection',
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      } else {
        Fluttertoast.showToast(
          msg: 'You are back online',
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );
      }
      previousResult = result;
    }
    if (previousResult == null && !result) {
      previousResult = result;
    }
  }

  bool connectionChecker(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi)) {
      return true;
    } else {
      return false;
    }
  }

  void dispose() {
    _subscription?.cancel();
    _connectionController.close(); // Close the stream controller when done
  }
}
