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
    _isLoading = true;
    notifyListeners();
    try {
      var res = await Userapi.GetProjectTimeSheetDetails(projectID);
      if (res != null && res.settings?.success == 1) {
        _timesheetlist = res.data ?? [];
        _filteredTimesheetsList = List.from(_timesheetlist); // Efficient copy
      } else {
        _timesheetlist = [];
        _filteredTimesheetsList = [];
      }
    } catch (e) {
      debugPrint("Error fetching timesheets: $e");
      _timesheetlist = [];
      _filteredTimesheetsList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int?> addLogtime(String start_time, String end_time, String note,
      String task_id, String projectID) async {
    try {
      var data = await Userapi.AddLogtimeApi(
          start_time, end_time, note, task_id, projectID);

      if (data != null && data.settings?.success == 1) {
        await fetchTimeSheetsList(projectID); // Ensure refreshed data
        return 1;
      }
    } catch (e) {
      debugPrint("Error adding logtime: $e");
    }
    return 0;
  }

  void filterTimesheets(String query) {
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      _filteredTimesheetsList = _timesheetlist.where((item) {
        final title = item.task?.toLowerCase() ?? '';
        return title.contains(lowerQuery);
      }).toList();
    } else {
      _filteredTimesheetsList = List.from(_timesheetlist); // Reset filter
    }
    notifyListeners();
  }
}
