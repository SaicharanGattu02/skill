import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';  // For ChangeNotifier
import '../Model/UserDetailsModel.dart';
import '../Services/UserApi.dart';

class ProfileProvider with ChangeNotifier {
  UserData? _userProfile;

  UserData? get userProfile => _userProfile;

  // Fetch user details from the repository
  Future<void> fetchUserDetails() async {
    try {
      var response = await Userapi.GetUserdetails();
      _userProfile=response?.data;
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch user details: $e');
    }
  }

  // Update user profile via the repository
  Future<bool> updateUserProfile(
     String fullName,
     String mobile,
     String gender,
     String linkdin,
     int status,
     String address,
     File? profileImage,
  ) async {
    try {
      final success = await Userapi.UpdateUserDetails(fullName, mobile, gender, linkdin, status, address, profileImage);
      if (success?.settings?.success==1) {
        // If successful, fetch updated details and notify listeners
        await fetchUserDetails();
        notifyListeners();
        return true;
      } else {
        return false;;
      }
    } catch (e) {
      throw Exception('Error updating user profile: $e');
    }
  }
}
