import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../Model/MileStoneModel.dart';
import '../Services/UserApi.dart'; // For ChangeNotifier


class MileStoneProvider with ChangeNotifier {
  List<Milestones> _milestones = [];
  List<Milestones> _filteredMilestones = [];
  bool _isLoading = true;

  // Getters to expose private fields
  List<Milestones> get milestones => _milestones;
  List<Milestones> get filteredMilestones => _filteredMilestones;
  bool get isLoading => _isLoading;

  // Fetch milestones from API
  Future<void> fetchMileStonesList(String projectID) async {
    try {
      var res = await Userapi.getMileStoneApi(projectID); // Adjust API call as necessary
      if (res != null && res.settings?.success==1) {
        _milestones = res.data??[];
        _filteredMilestones = res.data??[];
      } else {
        _milestones = res?.data??[];
        _filteredMilestones = res?.data??[];
      }
    } catch (e) {
      debugPrint("Error fetching milestones: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<int?> AddMileStone(name,desc,projectID,date) async {
    try {
      var res = await Userapi.PostMileStone(name,desc,projectID,date);
      if (res != null && res.settings?.success==1) {
        fetchMileStonesList(projectID);
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint("Error Adding milestones: $e");
    }
    return 0;
  }

  Future<int?>EditMileStone(projectID,milestoneID,name,desc,date) async {
    try {
      var res = await Userapi.putMileStone(milestoneID,name,desc,date); // Adjust API call as necessary
      if (res != null && res.settings?.success==1) {
        fetchMileStonesList(projectID);
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      debugPrint("Error Editing milestones: $e");
    }
    return 0;
  }

  void filterMileStones(String query) {
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      _filteredMilestones = _milestones.where((milestone) {
        final title = milestone.title?.toLowerCase() ?? '';
        final id = milestone.id?.toLowerCase() ?? '';
        return title.contains(lowerQuery) || id.contains(lowerQuery);
      }).toList();
    } else {
      _filteredMilestones = _milestones;
    }
    notifyListeners();
  }
}




