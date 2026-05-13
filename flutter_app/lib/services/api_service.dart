import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // 🔥 CHANGE THIS TO YOUR PC IP
  static const String baseUrl = "http://192.168.1.5:8000";

  static Future<String> predict(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("$baseUrl/predict"),
    );

    request.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      final respStr = await response.stream.bytesToString();
      final jsonData = json.decode(respStr);

      return jsonData['prediction']; // label
    } else {
      return "Error";
    }
  }
}