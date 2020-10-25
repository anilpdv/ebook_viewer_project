import 'dart:async';
import 'dart:convert';
import 'package:bookz/constants.dart';
import 'package:bookz/utils/helper.dart';
import 'package:http/http.dart' as http;

class BooksService {
  Future<dynamic> getData(String url) async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      var reqData = json.decode(response.body);
      return reqData;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Books, Try again!.');
    }
  }

  Future<List<dynamic>> getBooksData(String query) async {
    var reqData = await getInitialReqIds(query);
    var reqUrl = reqData['reqUrl'].toString();
    http.Response response = await http.get(reqUrl);
    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      List<dynamic> books = json.decode(response.body);

      return transformBooksList(books, reqData);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Books, Try again!.');
    }
  }

  List<dynamic> transformBooksList(List<dynamic> books, reqData) {
    var transformedBooks = [];

    books.forEach((element) {
      var book = element;

      // setting download url
      book['download'] = getEncodedUri(element, reqData);

      // setting filesizse
      book['filesize'] = convertBits(element['filesize']);

      // push to the books
      transformedBooks.add(book);
    });

    return transformedBooks;
  }

  Future<dynamic> getLatestData(String url) async {
    http.Response downloadResponse = await http.get(kAPI_URL + kDownloadUri);
    http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      print(response.statusCode);
      print(response.body);
      var reqData = json.decode(downloadResponse.body);
      var books = json.decode(response.body);
      return transformBooksList(books, reqData);
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load Books, Try again!.');
    }
  }

  Future<dynamic> getInitialReqIds(String query) async {
    var urlData;
    var niceQuery;
    var finalLink;
    List refinedData = [];
    Map<String, dynamic> reqData = {'durl': '', 'reqUrl': ''};

    http.Response downloadResponse = await http.get(kAPI_URL + kDownloadUri);

    if (downloadResponse.statusCode == 200) {
      urlData = json.decode(downloadResponse.body);
    } else {
      throw Exception('Failed to load urls, internal error');
    }

    if (downloadResponse.statusCode == 200) {
      niceQuery = query.split(' ').join('+');
      finalLink = urlData['searchUrl'] + niceQuery + '&page=1';
    }

    try {
      http.Response response = await http.get(finalLink);

      var fetchedData = kRegex.allMatches(response.body);
      for (var match in fetchedData) {
        refinedData.add(match[1]);
      }
    } catch (err) {
      throw Exception(
        'Books doesn\'t exist on this query, try different query.',
      );
    }

    if (refinedData.length > 0) {
      var joinedIds = refinedData.join(',');
      reqData['durl'] = urlData['durl'];
      reqData['reqUrl'] = urlData['dataUrl'] + joinedIds;
    }

    return reqData;
  }
}
