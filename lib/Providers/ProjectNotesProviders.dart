import 'package:flutter/cupertino.dart';
import '../Model/CompanyRegisteration.dart';
import '../Model/GetEditProjectNoteModel.dart';
import '../Model/ProjectNoteModel.dart';
import '../Services/UserApi.dart';

class ProjectNoteProviders extends ChangeNotifier {
  List<Notes> _data = [];
  List<Notes> _filteredData = [];
  bool _isLoading = true;

  List<Notes> get data => _data;
  List<Notes> get filteredData => _filteredData;
  bool get Loading => _isLoading;

  Future<void> GetNote(id) async {
    _isLoading = true;
    notifyListeners();
    var res = await Userapi.GetProjectNote(id);
    if (res != null) {
      if (res.settings?.success == 1) {
        _isLoading = false;
        _data = res.data ?? [];
        _filteredData = res.data ?? [];
        notifyListeners();
      } else {
        _isLoading = false;
        _data = res.data ?? [];
        _filteredData = res.data ?? [];
        notifyListeners();
        // CustomSnackBar.show(context, res.settings?.message ?? "");
      }
    } else {
      print("Task Failure  ${res?.settings?.message}");
    }
  }

  void filterNotes(String query) {
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      _filteredData = data.where((milestone) {
        final title = milestone.title?.toLowerCase() ?? '';
        final id = milestone.id?.toLowerCase() ?? '';
        return title.contains(lowerQuery) || id.contains(lowerQuery);
      }).toList();
    } else {
      _filteredData = data;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<int?> PostAddNoteApi(String editid, String title, String description,
      filepath, String id) async {
    _isLoading = true;
    notifyListeners();
    var res;
    try {
      if (editid.isNotEmpty) {
        res =
            await Userapi.PutEditNote(editid, title, description, filepath, id);
      } else {
        res = await Userapi.PostAddNote(title, description, filepath, id);
      }

      if (res != null) {
        // Check if the response indicates success
        if (res.settings?.success == 1) {
          _isLoading = false;
          GetNote(id);
          notifyListeners();
          return 1; // Success
        } else {
          _isLoading = false;
          notifyListeners();
          print("Error: ${res.settings?.message}");
          return 0; // Failure, server returned error
        }
      } else {
        _isLoading = false;
        notifyListeners();
        print("PostAddNoteApi >>> Null response");
        return 0; // No response received
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      print("Exception occurred: $e");
      return 0; // Failure due to exception
    }
  }

  Future<EditData?> GetEditDetails(String editid) async {
    var res = await Userapi.GetProjectEditNotes(editid);
    if (res != null) {
      if (res.settings?.success == 1) {
        notifyListeners();
        return res.editData;
      } else {
        notifyListeners();
        return null;
      }
    }
    return null;
  }

  Future<int?> DelateApi(String id) async {
    var res = await Userapi.ProjectDelateNotes(id);

    if (res != null) {
      _isLoading = false;
      if (res.settings?.success == 1) {
        // GetNote();
        // CustomSnackBar.show(context, "${res.settings?.message}");
        return 1;
      } else {
        // CustomSnackBar.show(context, "${res.settings?.message}");
        return 0;
      }
    } else {
      print("DelateApi >>>${res?.settings?.message}");
      // CustomSnackBar.show(context, "${res?.settings?.message}");
    }
  }
}
