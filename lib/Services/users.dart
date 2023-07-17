import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String baseUrl = 'https://technicians.onrender.com'; // Replace with your API URL

  // Method to send a reset password email
  static Future<String> sendResetPasswordEmail(String email) async {
    final url = Uri.parse('$baseUrl/sendResetPasswordEmail');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return 'Reset password email sent successfully';
    } else {
      throw Exception('Failed to send reset password email');
    }
  }

  // Method to verify reset password OTP
  static Future<String> verifyResetPasswordOTP(
      String email, String otp, String newPassword) async {
    final url = Uri.parse('$baseUrl/verifyResetPasswordOTP');
    final response = await http.post(
      url,
      body: jsonEncode({'email': email, 'otp': otp, 'newPassword': newPassword}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return 'Password reset successfully';
    } else {
      throw Exception('Failed to verify reset password OTP');
    }
  }

  // Method to get all users (requires admin role)
  static Future<List<dynamic>> getAllUsers(String token) async {
    final url = Uri.parse('$baseUrl/getAllUsers');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final users = jsonDecode(response.body);
      return users;
    } else {
      throw Exception('Failed to get users');
    }
  }

  // Method to register a new user
  static Future<Map<String, dynamic>> register(
      {required String name, required String email, required String password, required String location, required String phone}) async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.post(
      url,
      body: jsonEncode({'name': name, 'email': email, 'password': password,'location':location,'phone':phone}),
      headers: {'Content-Type': 'application/json; charset=utf-8'},
    );

    print(response.statusCode);
    print("i was printed from here");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data);
      return {
        'token': data['token'],
        'user': data,
      };
    } else {
      throw Exception('Failed to register user');
    }
  }

  // Method to log in a user
  static Future<Map?> login(String email, String password) async {
    try{
      final url = Uri.parse('$baseUrl/users/login');
      String ?token = await FirebaseMessaging.instance.getToken();
      final response = await http.post(
        url,
        body: jsonEncode({'email': email, 'password': password, 'token' : token}),
        headers: {'Content-Type': 'application/json'},
      );


      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
        await sharedPreferences.setString('token', data['token']);
        await sharedPreferences.setString('user', jsonEncode(data['user']));
        return data;
      } else {
        return null;
      }
    }catch(error){
      print(error.toString());
      return null;
    }
  }

  static Future<List<dynamic>> getAllFavoriteTechnicians(List techs) async {
    final url = Uri.parse('https://technicians.onrender.com/users/favorites');
    final headers = {'Content-Type': 'application/json; charset=utf-8'};
    final body = {'techs': jsonEncode(techs)};

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));
      print(response.statusCode);

      if (response.statusCode == 200) {
        final List<dynamic> techsArr = jsonDecode(response.body);
        return techsArr;
      } else {
        throw Exception('Failed to get favorite technicians');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

  static Future<List<dynamic>> createFavoriteTech(String userId, String id) async {
    final url = Uri.parse('https://technicians.onrender.com/users/favorites/create');
    final headers = {'Content-Type': 'application/json'};
    final body = {'userId': userId, 'id': id};

    try {
      final response = await http.post(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final List<dynamic> techs = jsonDecode(response.body);
        return techs;
      } else {
        throw Exception('Failed to create favorite technician');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

  static Future<List<dynamic>> deleteFavoriteTech(String userId, String id) async {
    final url = Uri.parse('https://technicians.onrender.com/users/favorites/$id');
    final headers = {'Content-Type': 'application/json'};
    final body = {'userId': userId};

    try {
      final response = await http.delete(url, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final List<dynamic> techs = jsonDecode(response.body);
        return techs;
      } else {
        throw Exception('Failed to delete favorite technician');
      }
    } catch (error) {
      throw Exception('Network error: $error');
    }
  }

  // Method to get a user by ID (requires user's own ID or admin role)
  static Future<Map?> getUser(String userId) async {
    final url = Uri.parse('$baseUrl/users/$userId');
    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      final Map user = jsonDecode(response.body);
      return user;
    } else {
      return null;
    }
  }

  // Method to delete a user by ID (requires user's own ID or admin role)
  static Future<String> deleteUser(String userId, String token) async {
    final url = Uri.parse('$baseUrl/deleteUser/$userId');
    final response = await http.delete(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      return 'User deleted successfully';
    } else {
      throw Exception('Failed to delete user');
    }
  }

  // Method to update a user by ID (requires user's own ID or admin role)
  static Future<dynamic> updateUser(
      String userId, String name, String email, String token) async {
    final url = Uri.parse('$baseUrl/updateUser/$userId');
    final response = await http.put(
      url,
      body: jsonEncode({'name': name, 'email': email}),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final user = jsonDecode(response.body);
      return user;
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Method to upload user image
  static Future<dynamic> uploadUserImage(
      {required String userId, required String imagePath}) async {
    final url = Uri.parse('$baseUrl/users/$userId/uploadImage');
    final request = http.MultipartRequest('PUT', url);
    request.files.add(await http.MultipartFile.fromPath('image', imagePath));

    final response = await request.send();
    print(response.statusCode);
    if (response.statusCode == 200) {
      final updatedUser = await response.stream.bytesToString();
      print(updatedUser);
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString('user', jsonEncode(updatedUser));

      return updatedUser;
    } else {
      print("so that has ereror ???");
      throw Exception('Failed to upload user image');
    }
  }
}
