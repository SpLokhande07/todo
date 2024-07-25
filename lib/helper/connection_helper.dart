import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectionHelper {
  final BuildContext context;
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _subscription;
  ConnectivityResult? _previousResult;

  ConnectionHelper(this.context);

  void initialize() {
    _subscription = _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      _showSnackbar(result);
    });
  }

  void _showSnackbar(List<ConnectivityResult> result) {
    if (result.contains(_previousResult)) {
      if (result.contains(ConnectivityResult.none)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You have lost internet connection'),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You are back online'),
            backgroundColor: Colors.green,
          ),
        );
      }
      _previousResult = result[0];
    }
  }

  void dispose() {
    _subscription?.cancel();
  }
}
