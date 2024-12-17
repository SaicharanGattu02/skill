import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../Model/TimeSheeetDeatilModel.dart';
import '../Services/UserApi.dart';


class TimesheetProvider with ChangeNotifier {
  List<TimeSheetList> _timesheetlist = [];
  List<TimeSheetList> _filteredTimesheetsList = [];
  bool _isLoading = true;


  List<TimeSheetList> get timesheetlist => _timesheetlist;
  List<TimeSheetList> get filteredTimesheetsList => _filteredTimesheetsList;
  bool get isLoading => _isLoading;

  Future<void> fetchTimeSheetsList(String projectID) async {
    try {
      _isLoading = true;
      var res = await Userapi.GetProjectTimeSheetDetails(projectID);
      if (res != null && res.settings?.success==1) {
        _timesheetlist = res.data??[];
        _filteredTimesheetsList = res.data??[];
      } else {
        _timesheetlist = res?.data??[];
        _filteredTimesheetsList = res?.data??[];
      }
    } catch (e) {
      debugPrint("Error fetching timesheets: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> Addlogtime(String start_time, String end_time,
      String note, String task_id, String projectID) async {
    var data = await Userapi.AddLogtimeApi(
         start_time, end_time,
         note, task_id, projectID);
    if (data != null) {
      if (data.settings?.success == 1) {
      } else {
      }
    } else {}
  }

  void filterTimesheets(String query) {
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      _filteredTimesheetsList = _timesheetlist.where((item) {
        final title = item.task?.toLowerCase() ?? '';
        return title.contains(lowerQuery);
      }).toList();
    } else {
      _filteredTimesheetsList = _timesheetlist;
    }
    notifyListeners();
  }


}




