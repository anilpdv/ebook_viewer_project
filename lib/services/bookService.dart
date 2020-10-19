import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BooksService {
  Future<List<dynamic>> getData(String url) async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      List<dynamic> books = json.decode(response.body);
      return books;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Books');
    }
  }
}
