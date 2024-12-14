import 'package:flutter/material.dart';
import 'package:skill/Services/UserApi.dart';

import '../Model/DashboardTaksModel.dart';

class TaskProvider extends ChangeNotifier {
  List<Data> _data = [];
  List<Data> _filteredData = [];
  bool _isLoading = true;

  List<Data> get data => _data;
  List<Data> get fillterData => _filteredData;
  bool get isLoading => _isLoading;

  Future<void> GetTasksList(String date) async {
    var res = await Userapi.gettaskaApi(date);
    if (res != null) {
      if (res.settings?.success == 1) {
        _data = res.data ?? [];
        _filteredData = data;
        notifyListeners();
_isLoading=false;
      } else {
        _data = [];
        _filteredData = [];
      }
    }
  }
}
