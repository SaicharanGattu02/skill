import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import '../Model/ProjectLabelColorModel.dart';
import '../Model/ProjectLabelModel.dart';
import '../Model/ToDoListModel.dart';
import '../Services/UserApi.dart';

class TODOProvider with ChangeNotifier {
  List<TODOList> _todolist = [];
  List<TODOList> _filteredData = [];
  List<Label> _labels = [];
  List<Label> _filteredLabels = [];
  List<LabelColor> _labelcolor = [];

  String? selectedLabelvalue;
  String? selectedLabelID;
  String? selectedValue;

  bool _isLoading = true;
  List<TODOList> get todolist => _todolist;
  List<TODOList> get filteredData => _filteredData;
  List<Label> get labels => _labels;
  List<LabelColor> get labelcolor => _labelcolor;
  List<Label> get filteredLabels => _filteredLabels;
  bool get isLoading => _isLoading;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<void> GetToDoList(date) async {
    _setLoading(true);
    var res = await Userapi.TODOListApi(
        date, selectedLabelID ?? "", selectedValue ?? "");

    if (res != null) {
      if (res.settings?.success == 1) {
        notifyListeners();
        _isLoading = false;
        _todolist = res.data ?? [];
        _filteredData = _todolist.reversed.toList();
      } else {
        notifyListeners();
        _isLoading = false;
      }
    }
  }

  Future<void> GetLabel() async {
    _isLoading = true;
    notifyListeners();
    var res = await Userapi.GetProjectsLabelApi();
    if (res != null && res.label != null) {
      _isLoading = false;
      notifyListeners();
      _labels = res.label ?? [];
      _filteredLabels = res.label ?? [];
    } else {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchTODOList(date) async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await Userapi.gettodolistApi(date);
      if (response != null) {
        if (response.settings?.status == 1) {
          _todolist = response.data ?? [];
          notifyListeners();
          _isLoading = false;
        } else {
          _todolist;
          _isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<void> fetchLabels() async {
    _isLoading = true;
    notifyListeners();
    try {
      var response = await Userapi.GetProjectsLabelApi();
      if (response != null) {
        if (response.settings?.status == 1) {
          _labels = response.label ?? [];
          notifyListeners();
          _isLoading = false;
        } else {
          _isLoading = false;
          notifyListeners();
        }
      }
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  Future<void> GetLabelColor() async {
    _setLoading(true);
    var res = await Userapi.GetProjectsLabelColorApi();
    if (res != null && res.data != null) {
      _setLoading(true);
      _labelcolor = res.data ?? [];
    } else {
      _setLoading(true);
    }
  }
}
