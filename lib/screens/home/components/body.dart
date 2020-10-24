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

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
          child: Text(
            "Books",
            style: Theme.of(context)
                .textTheme
                .headline5
                .copyWith(fontWeight: FontWeight.bold),
          ),
        ),
        Categories(),
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
