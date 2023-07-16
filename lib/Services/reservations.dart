import 'dart:convert';
import 'package:http/http.dart' as http;

class ReservationService {
  static const String baseUrl = 'https://technicians.onrender.com'; // Replace with your API base URL

  // Create a new reservation
  static Future<dynamic> createReservation(String userId, String technicianId, String date, int time) async {
    final response = await http.post(
      Uri.parse('$baseUrl/reservations'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'userId': userId,
        'technicianId': technicianId,
        'date': date,
        'time':time
      }),
    );

    if (response.statusCode == 201) {
      final String reservation = response.body;
      return reservation;
    } else{
      return throw response.body;
    }
  }

  // Get all reservations
  static Future<List<dynamic>> getAllReservations() async {
    final response = await http.get(Uri.parse('$baseUrl/reservations'));
    if (response.statusCode == 200) {
      final reservations = jsonDecode(response.body);
      return reservations;
    } else {
      throw Exception('Failed to fetch reservations');
    }
  }

  // Delete a reservation
  static Future<void> deleteReservation(String id) async {
    final response = await http.delete(Uri.parse('$baseUrl/reservations/$id'));
    if (response.statusCode == 200) {
      return;
    } else if (response.statusCode == 404 && response.body.contains('Reservation not found')) {
      throw Exception('Reservation not found');
    } else {
      throw Exception('Failed to delete reservation');
    }
  }

  static Future<List<dynamic>> getUserReservations(String userId) async {
    try {
      // Make API request to get user reservations
      final response = await http.get(Uri.parse('https://technicians.onrender.com/reservations/user/$userId'));

      if (response.statusCode == 200) {
        // Parse response JSON
        final List<dynamic> reservations = json.decode(response.body);

        return reservations;
      } else {
        throw Exception('Failed to get user reservations');
      }
    } catch (error) {
      throw Exception('Failed to connect and get user reservations: $error');
    }
  }

}