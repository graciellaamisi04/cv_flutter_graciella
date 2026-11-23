import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2/api-test/public';

  static const Duration timeoutDuration = Duration(seconds: 20);

  static const Map<String, String> _jsonHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static Map<String, dynamic> _traiterReponse(http.Response response) {
    try {
      final decoded = jsonDecode(response.body);

      if (decoded is Map<String, dynamic>) {
        return {
          ...decoded,
          'statusCode': response.statusCode,
        };
      }

      return {
        'success': false,
        'statusCode': response.statusCode,
        'message': 'Format de réponse JSON inattendu.',
      };
    } catch (_) {
      final extrait = response.body.length > 200
          ? '${response.body.substring(0, 200)}...'
          : response.body;

      return {
        'success': false,
        'statusCode': response.statusCode,
        'message': response.body.isEmpty
            ? 'Le serveur a retourné une réponse vide (HTTP ${response.statusCode}).'
            : 'Réponse non-JSON (HTTP ${response.statusCode}) : $extrait',
      };
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/accounts/login'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(timeoutDuration);

    return _traiterReponse(response);
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/accounts/register'),
          headers: _jsonHeaders,
          body: jsonEncode({
            'email': email.trim(),
            'password': password,
          }),
        )
        .timeout(timeoutDuration);

    return _traiterReponse(response);
  }

  static Future<List<dynamic>> getMembres() async {
    final response = await http
        .get(
          Uri.parse('$baseUrl/famille-membres'),
          headers: {'Accept': 'application/json'},
        )
        .timeout(timeoutDuration);

    final data = _traiterReponse(response);

    if (response.statusCode >= 200 &&
        response.statusCode < 300 &&
        data['success'] == true) {
      return data['data'] is List ? List<dynamic>.from(data['data']) : [];
    }

    throw Exception(
      data['message']?.toString() ??
          'Erreur lors du chargement des membres.',
    );
  }

  static Future<Map<String, dynamic>> createMembreJson(
    Map<String, dynamic> body,
  ) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl/famille-membres'),
          headers: _jsonHeaders,
          body: jsonEncode(body),
        )
        .timeout(timeoutDuration);

    return _traiterReponse(response);
  }

  static Future<Map<String, dynamic>> updateMembreJson(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await http
        .put(
          Uri.parse('$baseUrl/famille-membres/$id'),
          headers: _jsonHeaders,
          body: jsonEncode(body),
        )
        .timeout(timeoutDuration);

    return _traiterReponse(response);
  }

  static Future<Map<String, dynamic>> saveMembreMultipart({
    int? id,
    required Map<String, String> fields,
    String? imagePath,
  }) async {
    final String url = id == null
        ? '$baseUrl/famille-membres'
        : '$baseUrl/famille-membres/$id';

    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Accept'] = 'application/json';

    request.fields.addAll(fields);
    if (id != null) {
      // Utile pour les backends PHP/Laravel qui simulent PUT en multipart
      request.fields['_method'] = 'PUT';
    }

    if (imagePath != null && imagePath.isNotEmpty) {
      request.files.add(
        await http.MultipartFile.fromPath('image', imagePath),
      );
    }

    final streamedResponse = await request.send().timeout(timeoutDuration);
    final response = await http.Response
        .fromStream(streamedResponse)
        .timeout(timeoutDuration);

    return _traiterReponse(response);
  }

  static Future<Map<String, dynamic>> deleteMembre(int id) async {
    final response = await http
        .delete(
          Uri.parse('$baseUrl/famille-membres/$id'),
          headers: {'Accept': 'application/json'},
        )
        .timeout(timeoutDuration);

    return _traiterReponse(response);
  }
}