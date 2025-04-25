import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class ApiService {
  // 🖥️ Replace with your system IP or server URL
  static const String baseUrl = "http://192.168.15.219:8000";

  static Future<Map<String, dynamic>> predictDisease(String filename, Uint8List imageBytes) async {
    final uri = Uri.parse('$baseUrl/predict');

    var request = http.MultipartRequest('POST', uri);
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200 && responseBody.isNotEmpty) {
      return json.decode(responseBody) as Map<String, dynamic>;
    } else {
      throw Exception("Prediction failed: ${response.statusCode} - $responseBody");
    }
  }
}
