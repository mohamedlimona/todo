import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';


class check_Internet extends ChangeNotifier{
  StreamSubscription<DataConnectionStatus> listener;

  Future<bool> check() async {

  DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus.connected:
          return true;
          break;
        case DataConnectionStatus.disconnected:
          return false;
          break;
      }
    });

    await Future.delayed(Duration(seconds: 30));
    await listener.cancel();
  }

  Future<bool> check_Connection() async {
    bool result = await DataConnectionChecker().hasConnection;

    if (result == true) {
      return true;
    } else {

      return false;
    }
  }
}
