import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For ChangeNotifier
import '../Model/ProjectLabelModel.dart';
import '../Model/ToDoListModel.dart';
import '../Services/UserApi.dart';

class TODOProvider with ChangeNotifier {
  List<TODOList>? _todolist;
  List<Label>?  _labels;

  List<TODOList>? get todolist => _todolist;
  List<Label>? get labels => _labels;

  // Fetch user details from the repository
  Future<void> fetchTODOList(date) async {
    try {
      var response = await Userapi.gettodolistApi(date);
      _todolist=response?.data;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  // Fetch user details from the repository
  Future<void> fetchLabels() async {
    try {
      var response = await Userapi.GetProjectsLabelApi();
      _labels=response?.label;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

}
