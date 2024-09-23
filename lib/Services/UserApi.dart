import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;



class Userapi {
  //
  // static Future<BookApointmentModel?> Apointment(
  //     String fname,
  //     String pnum,
  //     String appointment,
  //     String age,
  //     String appointment_type,
  //     String Date_of_appointment,
  //     String location,
  //     String page_source,
  //     String time_of_appointment,
  //     String user_id
  //     ) async {
  //   try {
  //     final body = jsonEncode({
  //       'Full_Name': fname,
  //       'phone_Number': pnum,
  //       'appointment':appointment,
  //       'age': age,
  //       'appointment_type': appointment_type,
  //       'Date_of_appointment': Date_of_appointment,
  //       'location': location,
  //       'user_id': user_id,
  //     });
  //     print("Apointment data: $body");
  //
  //     final url = Uri.parse("https://admin.neuromitra.com/api/bookappointments?page_source=${page_source}&time_of_appointment=${time_of_appointment}");
  //     print("${url}");
  //     print("${page_source}");
  //     final headers = {
  //       'Content-Type': 'application/json'
  //     };
  //     final response = await http.post(
  //       url,
  //       headers: headers,
  //       body: body,
  //     );
  //     // if (response.statusCode == 200) {
  //     final jsonResponse = jsonDecode(response.body);
  //     // print("Response JSON: ${jsonResponse}");
  //     print("Apointment Status:${response.body}");
  //
  //     return BookApointmentModel.fromJson(jsonResponse);
  //     // } else {
  //     //   print("Request failed with status: ${response.statusCode}");
  //     //   return null;
  //     // }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     return null;
  //   }
  // }
  //
  //
  // static Future<RegisterModel?> PostRegister(String name,String mail, String password,String phone) async {
  //   try {
  //     Map<String, String> data = {
  //       "name":name,
  //       "email": mail,
  //       "password": password,
  //       "phone": phone,
  //     };
  //     final url = Uri.parse("https://admin.neuromitra.com/api/user-signup");
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //       },
  //       body: jsonEncode(data),
  //     );
  //     if (response!=null) {
  //       final jsonResponse = jsonDecode(response.body);
  //       print("PostRegister Status:${response.body}");
  //       return RegisterModel.fromJson(jsonResponse);
  //     } else {
  //       print("Request failed with status: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     return null;
  //   }
  // }
  //
  //
  //
  // static Future<LoginModel?> PostLogin(String mail, String password) async {
  //   try {
  //     Map<String, String> data = {
  //       "email": mail,
  //       "password": password,
  //     };
  //     print("PostLogin: $data");
  //     final url = Uri.parse("https://admin.neuromitra.com/api/user-signin");
  //     print("PostLogin : $url");
  //     final response = await http.post(
  //       url,
  //       headers: {
  //         HttpHeaders.contentTypeHeader: "application/json",
  //       },
  //       body: jsonEncode(data),
  //     );
  //     if (response != null) {
  //       final jsonResponse = jsonDecode(response.body);
  //       print("PostLogin Status:${response.body}");
  //       return LoginModel.fromJson(jsonResponse);
  //     } else {
  //       print("Request failed with status: ${response.statusCode}");
  //       return null;
  //     }
  //   } catch (e) {
  //     print("Error occurred: $e");
  //     return null;
  //   }
  // }


}
