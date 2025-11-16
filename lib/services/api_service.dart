import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/channel.dart';

class ApiService {
  // Update this to your backend URL
  // For Android emulator: use http://10.0.2.2:3000
  // For iOS simulator: use http://localhost:3000
  // For physical device: use your computer's IP address
  static const String baseUrl = 'https://broadcast-backend-mgqz.onrender.com';

  static Future<List<Channel>> fetchChannels() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/channels'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Channel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load channels: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching channels: $e');
    }
  }
}


