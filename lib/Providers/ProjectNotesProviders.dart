import 'package:flutter/cupertino.dart';

import '../Model/CompanyRegisteration.dart';
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
    _isLoading = true;
    notifyListeners();
    if (query.isNotEmpty) {
      final lowerQuery = query.toLowerCase();
      _filteredData = data.where((milestone) {
        final title = milestone.title?.toLowerCase() ?? '';
        final id = milestone.id?.toLowerCase() ?? '';
        return title.contains(lowerQuery) || id.contains(lowerQuery);
      }).toList();
    } else {
      _filteredData = data;
    }
    notifyListeners();
  }


  Future<void> PostAddNoteApi(String editid,title,description,filepath,id) async {
    var res;
    if (editid != "") {
      res = await Userapi.PutEditNote(
        editid,
      title,description,filepath,id
      );
    } else {
      res = await Userapi.PostAddNote(
      title,description,filepath,id
      );
    }
    if (res != null) {
      if (res.settings?.success == 1) {
        // Navigator.pop(context);
        // GetNote();
      } else {}
    } else {
      print("PostAddNoteApi >>>${res?.settings?.message}");
      // CustomSnackBar.show(context, "${res?.settings?.message}");
    }
  }

  Future<void> DelateApi(String id) async {
    var res = await Userapi.ProjectDelateNotes(id);

    if (res != null) {

        _isLoading = false;
        if (res.settings?.success == 1) {
          // GetNote();
          // CustomSnackBar.show(context, "${res.settings?.message}");
        } else {
          // CustomSnackBar.show(context, "${res.settings?.message}");
        }

    } else {
      print("DelateApi >>>${res?.settings?.message}");
      // CustomSnackBar.show(context, "${res?.settings?.message}");
    }
  }
}
