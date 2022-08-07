import 'dart:convert';

import 'package:comick_application/requests/Models/comickModel.dart';
import 'package:http/http.dart' as http;

Future<List<Comick>> getComicsByName(String? value) async {
  final queryParameters = {'q': value};
  final response = await http.get(Uri.https('api.comick.fun', '/search', queryParameters));

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body) as List<dynamic>;
    return jsonResponse.map((e) => Comick.fromJson(e)).toList();
  } else {
    throw Exception('Failed to load comick');
  }
}