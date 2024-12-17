import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../Model/MileStoneModel.dart';
import '../Model/TasklistModel.dart';
import '../Services/UserApi.dart'; // For ChangeNotifier


class TasklistProvider with ChangeNotifier {
  List<TaskListData> _tasks = [];
  List<TaskListData> _filteredTasks = [];
  bool _isLoading = true;
  List<TaskListData> get tasks => _tasks;
  List<TaskListData> get filteredTasks => _filteredTasks;
  bool get isLoading => _isLoading;

  // Fetch milestones from API
  Future<void> fetchTasksList(String projectID, milestoneid, statusid,
  assignedid, priorityid,date) async {
    try {
      _isLoading = true;
      var res = await Userapi.GetTask(projectID, milestoneid, statusid,
          assignedid, priorityid,date);
      if (res != null && res.settings?.success==1) {
        _tasks = res.data??[];
        _filteredTasks = res.data??[];
      } else {
        _tasks = res?.data??[];
        _filteredTasks = res?.data??[];
      }
    } catch (e) {
      debugPrint("Error fetching tasks: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int?> AddTask(
      String projectId,
      String title,
      String desc,
      String milestone,
      String assignedTo,
      String status,
      String priority,
      String startDate,
      String endDate,
      List<String> collaborators,
      File? image, // Make image optional
          {int points = 3}) async {
    try {
      var res = await Userapi.CreateTask(
           projectId,
           title,
           desc,
           milestone,
           assignedTo,
           status,
           priority,
           startDate,
           endDate,
          collaborators,
          image, // Make image optional
         );
      if (res != null && res.settings.success==1) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint("Error Adding task: $e");
    }
    return 0;
  }

  Future<int?>EditTask(
      String taskId,
      String title,
      String desc,
      String milestone,
      String assignedTo,
      String status,
      String priority,
      String startDate,
      String endDate,
      List<String> collaborators,
      File? image
      ) async {
    try {
      var res = await Userapi.updateTask(
           taskId,
           title,
           desc,
           milestone,
           assignedTo,
           status,
           priority,
           startDate,
           endDate,
           collaborators,
           image
      ); // Adjust API call as necessary
      if (res != null && res.settings.success==1) {
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint("Error Editing milestones: $e");
    }
    return 0;
  }

// Deleting a task by id and removing it from both _tasks and _filteredTasks
  Future<int?> deleteTask(id) async {
    try {
      var res = await Userapi.ProjectDelateTask(id);
      if (res != null && res.settings?.success == 1) {
        // Remove task from both lists
        _tasks.removeWhere((task) => task.id == id);
        _filteredTasks.removeWhere((task) => task.id == id);
        // Notify listeners after removal
        notifyListeners();

        return 1;  // Success
      } else {
        return 0;  // Failure
      }
    } catch (e) {
      debugPrint("Error delete task: $e");
    }
    return 0;
  }


  void filterTasksList(String query) {
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();  // Store the lowercase query here.
      _filteredTasks = _tasks.where((item) {
        final title = item.title?.toLowerCase() ?? '';  // Ensure title is not null
        final description = item.description?.toLowerCase() ?? '';  // Ensure description is not null
        return title.contains(lowerQuery) || description.contains(lowerQuery);
      }).toList();
    } else {
      _filteredTasks = _tasks;
    }
    notifyListeners();
  }


}




