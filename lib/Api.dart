import 'dart:convert';

import 'package:task/Model/SchemeModel.dart';
import 'package:http/http.dart' as http;

import 'Constant.dart';
class Api{
  static Future<SchemeModel?> fetchSchemeApi(int page) async {
    final response = await http.get(Uri.parse('https://test.bookinggksm.com/api/scheme/view-scheme/55?page=${page}&limit=10'),
        headers: {
          'authorization': 'Bearer ${Constant.token}'
        },
    );
    if (response.statusCode == 200) {
      try {
        final jsonString = jsonDecode(response.body);
        print(jsonString);
        return SchemeModel.fromJson(jsonString);
      } catch (e) {
        print('Error parsing JSON schemeApi: $e');
        return null;
      }
    } else {
      print('Request failed with status schemeApi: ${response.statusCode}');
      print('Response body: ${response.body}');
      return null;
    }

  }
}