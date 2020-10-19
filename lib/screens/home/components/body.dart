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
  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    BooksService booksService = BooksService();
    var response = await booksService.getData(kLATEST_URL);
    setState(() {
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
        BooksGrid(books: books)
      ],
    );
  }
}
