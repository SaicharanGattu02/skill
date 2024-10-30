import 'package:flutter/material.dart';
import 'package:skill/Model/TaskKanBanModel.dart';

class KanbanProvider with ChangeNotifier {
  List<Kanban> _todoData = [];
  List<Kanban> _inProgressData = [];
  List<Kanban> _completedData = [];

  List<Kanban> get todoData => _todoData;
  List<Kanban> get inProgressData => _inProgressData;
  List<Kanban> get completedData => _completedData;

  void setTodoData(List<Kanban> data) {
    _todoData = data;
    print('Todo data updated: $_todoData');
    notifyListeners();
  }

  void setInProgressData(List<Kanban> data) {
    _inProgressData = data;
    print('In Progress data updated: $_inProgressData');
    notifyListeners();
  }

  void setCompletedData(List<Kanban> data) {
    _completedData = data;
    print('Completed data updated: $_completedData');
    notifyListeners();
  }


  void updateTaskStatus(Kanban task, String newStatus) {
    // Remove the task from its current list
    if (_todoData.contains(task)) {
      _todoData.remove(task);
    } else if (_inProgressData.contains(task)) {
      _inProgressData.remove(task);
    } else if (_completedData.contains(task)) {
      _completedData.remove(task);
    }

    // Update the task status
    task.status = newStatus;

    // Add the task to the new list
    if (newStatus == 'To Do') {
      _todoData.add(task);
    } else if (newStatus == 'In Progress') {
      _inProgressData.add(task);
    } else if (newStatus == 'Done') {
      _completedData.add(task);
    }

    notifyListeners();
  }
}

