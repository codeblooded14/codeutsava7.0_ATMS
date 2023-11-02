import 'package:http/http.dart' as http;
import 'dart:convert';


Future<Map<String, dynamic>> getPredictions(
    Map<String, dynamic> inputData) async {
  final response = await http.post(
    Uri.parse('https://your-flask-backend-url.com/predict_price'),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode(inputData),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to get predictions');
  }
}
