import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skill/Model/ProjectCommentsModel.dart';
import '../Services/UserApi.dart';

class ProjectCommentProviders extends ChangeNotifier {
  List<ProjectComment> _projectComments = [];
  List<XFile> _imageList = [];
  bool _isLoading = true;

  List<ProjectComment> get projectComments => _projectComments;
  List<XFile> get imageList => _imageList;
  bool get isLoading => _isLoading;

  Future<void> GetProjectCommentsApi(id) async {
    try {
      var res = await Userapi.GetProjectComments(id);
      if (res != null && res.settings?.success == 1) {
        _isLoading = false;
        _projectComments = res.data ?? [];
      } else {
        _isLoading = false;
        _projectComments = res?.data ?? [];
      }
    } catch (e) {
      _isLoading = false;
      print("Error fetching project comments: $e");
    } finally {
      notifyListeners();
    }
  }

  Future<int?> SendComments(String comment, id) async {
    try {
      var res = await Userapi.sendComment(comment, id, _imageList);
      if (res != null && res.settings?.success == 1) {
        await GetProjectCommentsApi(id); // Refresh the comments after sending
        return 1;
      } else {
        return 0;
      }
    } catch (e) {
      print("Error sending comment: $e");
      return 0;
    }
  }

  Future<int?> DeleteComment(id) async {
    try {
      var res = await Userapi.ProjectDelateComments(id);
      if (res != null && res.settings?.success == 1) {
        // If the API call is successful, remove the comment from the list
        _projectComments.removeWhere((comment) => comment.id == id);
        notifyListeners();
        return 1; // Return success
      } else {
        return 0; // Return failure if the API response is unsuccessful
      }
    } catch (e) {
      print("Error deleting comment: $e");
      return 0; // Return failure if there's an error
    }
  }
}
