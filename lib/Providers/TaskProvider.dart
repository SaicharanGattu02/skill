import 'package:flutter/material.dart';
import 'package:skill/Services/UserApi.dart';

import '../Model/DashboardTaksModel.dart';

class TaskProvider extends ChangeNotifier {
  List<Data> _data = [];
  bool _isLoading = true;

  List<Data> get data => _data;
  bool get isLoading => _isLoading;

  Future<void> GetTasksList(String date) async {
    _isLoading = true;
    notifyListeners();
    var res = await Userapi.gettaskaApi(date);
    if (res != null) {
      if (res.settings?.success == 1) {
        _data = res.data ?? [];
         _isLoading=false;
        notifyListeners();
      } else {
        _data = [];
        _isLoading=false;
        notifyListeners();
      }
    }
  }
}
