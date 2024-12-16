import 'package:flutter/cupertino.dart';
import '../Model/EmployeeListModel.dart';
import '../Model/MeetingModel.dart';
import '../Model/MeetingProviders.dart';
import '../Model/ProjectsModel.dart';
import '../Services/UserApi.dart';

class MeetingProvider extends ChangeNotifier {
  List<Data> _meetings = [];
  List<Employeedata> _employeeData = [];
  List<ProjectsMeetingsModel> _projectsData = [];
  List<ProjectsMeetingsModel> _filteredProjectsData = [];
  List<Providers> _providers = [];
  List<Providers> _filteredProviders = [];
  bool _loading = true;

  List<Data> get meetings => _meetings;
  List<ProjectsMeetingsModel> get projectsData => _projectsData;
  List<ProjectsMeetingsModel> get filteredProjectsData => _filteredProjectsData;
  List<Employeedata> get employeeData => _employeeData;
  List<Providers> get providers => _providers;
  List<Providers> get filteredProviders => _filteredProviders;
  bool get loading => _loading;

  Future<void> getMeeting(String date) async {
    _loading = true;
    notifyListeners();
    var res = await Userapi.GetMeetingbydate(date);
    if (res != null) {
      if (res.settings?.success == 1) {
        _loading = false;
        _meetings = res.data ?? [];
        notifyListeners();
      } else {
        _meetings = res.data ?? [];
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> GetUsersdata() async {
    _loading = true;
    notifyListeners();
    var res = await Userapi.GetEmployeeList();
    if (res != null) {
      if (res.settings?.success == 1) {
        _loading = false;
        _employeeData = res.data ?? [];
        print("employeeData:${employeeData}");
        notifyListeners();
      } else {
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> GetProjectsData() async {
    _loading = true;
    notifyListeners();
    var res = await Userapi.GetProjectsList();
    if (res != null) {
      if (res.settings?.success == 1) {
        _loading = false;
        _projectsData = res.data ?? [];
        _filteredProjectsData = res.data ?? [];
        notifyListeners();
      } else {
        _loading = false;
        notifyListeners();
      }
    }
  }

  Future<void> GetMeetingProviders() async {
    _loading = true;
    notifyListeners();
    var res = await Userapi.fetchMeetingProviders();

    if (res != null) {
      if (res.settings?.success == 1) {
        _providers = res.data ?? [];
        _filteredProviders = res.data ?? [];
        notifyListeners();
      } else {
        _loading = false;
        notifyListeners();
      }
    }
  }

  void filterProviders(String query) {
    _filteredProviders = providers.where((provider) {
      return provider.providerValue != null &&
          provider.providerValue!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  void filterProjects(String query) {
    _filteredProjectsData = projectsData.where((provider) {
      return provider.name != null &&
          provider.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  Future<void> AddMeeting(
      _meetingtitleController,
      _descriptionController,
      selectedprojectkey,
      meeting_type,
      selectedIds,
      dateAndTime,
      meeting_link,
      _clientEmailController) async {
    String? meeting_type;
    String? meeting_link;
    _loading = true;
    notifyListeners();

    var res = await Userapi.postAddMeeting(
        _meetingtitleController,
        _descriptionController,
        selectedprojectkey!,
        meeting_type!,
        selectedIds,
        dateAndTime,
        meeting_link!,
        _clientEmailController);

    if (res != null) {
      if (res.settings?.success == 1) {
        _loading = false;
        notifyListeners();
        // final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
        // profileProvider.fetchUserDetails();
        // Navigator.pop(context, true);
        // CustomSnackBar.show(context, "Meeting Added Successfully!");
      } else {
        _loading = false;
        notifyListeners();
        // CustomSnackBar.show(context, "${res.settings?.message}");
      }
    }
  }
}
