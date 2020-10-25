import 'package:bookz/screens/home/components/book_grid.dart';
import 'package:bookz/services/bookService.dart';
import 'package:flutter/material.dart';

import 'package:bookz/constants.dart';
import 'package:bookz/screens/home/components/categories.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List books = [];
  bool loader = false;
  bool isError = false;
  String errorString = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    BooksService booksService = BooksService();
    DateTime now = new DateTime.now();
    DateTime before = now.subtract(Duration(days: 7));
    String today = now.toString().split(' ')[0];
    String fivedaysfromnow = before.toString().split(' ')[0];
    var url = kLATEST_URL + '&timefirst=$fivedaysfromnow' + '&timelast=$today';

    setState(() {
      loader = true;
    });

    var response = await booksService.getLatestData(url);

    setState(() {
      loader = false;
      books = response;
    });
  }

  fetchDataByQuery(String query) async {
    BooksService booksService = BooksService();
    var response;

    // : setting loading to true
    setState(() {
      loader = true;
      isError = false;
      errorString = "";
    });

    try {
      response = await booksService.getBooksData(query);
    } on Exception catch (e) {
      setState(() {
        isError = true;
        errorString = e.toString();
      });
      print('exception error $e');
    } catch (err) {
      print(err);
    }

    // setting books response to state
    setState(() {
      loader = false;
      books = response;
    });
  }

  fetchDataByCategory(String category) {
    if (category == 'Latest') {
      fetchData();
    } else {
      fetchDataByQuery(category);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Categories(
          getBooks: fetchDataByCategory,
        ),
        loader ? getLoader() : BooksGrid(books: books)
      ],
    );
  }

  Expanded getLoader() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
