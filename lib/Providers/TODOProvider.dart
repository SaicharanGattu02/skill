import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // For ChangeNotifier
import 'package:provider/provider.dart';
import '../Model/ProjectLabelColorModel.dart';
import '../Model/ProjectLabelModel.dart';
import '../Model/ToDoListModel.dart';
import '../Services/UserApi.dart';
import 'ProfileProvider.dart';

class TODOProvider with ChangeNotifier {
  List<TODOList> _todolist = [];
  List<TODOList> _filteredData = [];
  List<TODOList> _data = [];
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

  Future<void> fetchTODOList(date) async {
    _isLoading = true;
    notifyListeners();
    var res = await Userapi.TODOListApi(
        date, selectedLabelID ?? "", selectedValue ?? "");

    if (res != null) {
      if (res.settings?.success == 1) {
        _isLoading = false;
        _todolist = res.data ?? [];
        _data = res.data ?? [];
        _filteredData = _todolist.reversed.toList();
        notifyListeners();
      } else {
        _isLoading = false;
        _todolist = res.data ?? [];
        _data = res.data ?? [];
        _filteredData = _todolist.reversed.toList();
        notifyListeners();
      }
    }
  }

  Future<int> PostToDo(
      String taskName,
      String description,
      String date,
      String selectedValue,
      String selectedLabelID,
      String todayDate) async {
    try {
      var res = await Userapi.PostProjectTodo(
        taskName,
        description,
        date,
        selectedValue,
        selectedLabelID,
      );

      // Check if the API response is successful
      if (res?.settings?.success == 1) {
        fetchTODOList(todayDate);  // Refresh TODO list
        notifyListeners();
        return 1;  // Indicating success
      } else {
        print("Error: ${res?.settings?.message ?? 'Unknown error'}");
        notifyListeners();
        return 0;  // Indicating failure
      }
    } catch (e) {
      print("Error posting ToDo: $e");
      return 0;  // If an error occurs, return failure
    }
  }


  Future<void> PostToDoAddLabel(label_name, label_color) async {
    var res = await Userapi.PostProjectTodoAddLabel(label_name, label_color);
        // _labelnameController.text, labelColorid);
      if (res != null) {
        _isLoading = false;
        if (res.settings?.success == 1) {
          // Navigator.pop(context, true);
          // CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          // CustomSnackBar.show(context, "${res.settings?.message}");
        }
      } else {
        _isLoading = false;
      }
  }

  Future<int?> deleteToDoList(String id) async {
    var res = await Userapi.deleteTask(id);
      _isLoading = false;
      if (res != null) {
        if (res.settings?.success == 1) {
          _todolist.removeWhere((item) => item.id == id);
          _data.removeWhere((item) => item.id == id);
          _filteredData.removeWhere((item) => item.id == id);
          notifyListeners();
          return res.settings?.success??1;
        } else {
          return res.settings?.success??0;
        }
      }
      return 0;
  }

  Future<void> GetLabel() async {
    var res = await Userapi.GetProjectsLabelApi();
    if (res != null && res.label != null) {
      _labels = res.label ?? [];
      _filteredLabels = res.label ?? [];
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> GetLabelColor() async {
    var res = await Userapi.GetProjectsLabelColorApi();
    if (res != null && res.data != null) {
      _labelcolor = res.data ?? [];
      notifyListeners();
    } else {
      notifyListeners();
    }
  }

  Future<void> filterTasks(String query) async {
    if (query.isNotEmpty) {
      _filteredData = _data.where((task) {
        return (task.labelName?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (task.description?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
            (task.taskName?.toLowerCase().contains(query.toLowerCase()) ?? false);
      }).toList();
    } else {
      // Reset to original data when query is empty
      _filteredData = _data;
    }
    notifyListeners();
  }


  void filterLabels(String query) {
    if (query.isNotEmpty) {
      _filteredLabels = labels.where((provider) {
        return provider.name != null &&
            provider.name!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }else{
      _filteredLabels = labels;
    }
      notifyListeners();
  }
}



