import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:todo_noorisys/helper/connection_helper.dart';

import '../view/homescreen.dart';

class ConnectionWrapper extends StatefulWidget {
  final Widget child;
  const ConnectionWrapper({super.key, required this.child});

  @override
  _ConnectionWrapperState createState() => _ConnectionWrapperState();
}

class _ConnectionWrapperState extends State<ConnectionWrapper> {
  late ConnectionHelper _connectionHelper;

  @override
  void initState() {
    super.initState();
    _connectionHelper = ConnectionHelper(context);
    _connectionHelper.initialize();
  }

  @override
  void dispose() {
    _connectionHelper.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _connectionHelper.connectionStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool result = snapshot.data ?? false;
          if (result) {
            return const Scaffold(
              body: Center(
                child: Text('No internet connection'),
              ),
            );
          } else {
            return widget.child;
          }
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
