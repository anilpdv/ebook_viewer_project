import 'package:bookz/constants.dart';
import 'package:bookz/screens/home/components/book_grid.dart';
import 'package:bookz/services/bookService.dart';
import 'package:flutter/material.dart';
import 'package:beauty_textfield/beauty_textfield.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  List books = [];
  bool loader = false;
  bool isError = false;
  String errorString = '';
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  fetchData(String query) async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BeautyTextfield(
              width: double.maxFinite,
              height: 60,
              autofocus: false,
              duration: Duration(milliseconds: 300),
              inputType: TextInputType.text,
              fontFamily: 'Lato',
              textColor: Colors.grey[500],
              fontWeight: FontWeight.bold,
              obscureText: false,
              prefixIcon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              placeholder: "search books here...",
              onTap: () {
                print('Click');
              },
              onChanged: (text) {
                print(text);
              },
              onSubmitted: (data) {
                fetchData(data);
              },
            ),
            SizedBox(
              height: 20,
            ),
            loader ? getLoader() : getBooksGrid(),
            isError ? onError(context) : Container()
          ],
        ),
      ),
    );
  }

  BooksGrid getBooksGrid() {
    return BooksGrid(
      books: books,
    );
  }

  onError(BuildContext context) {
    final snackBar = SnackBar(
      duration: Duration(seconds: 10),
      content: Text(errorString),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {
          // Some code to undo the change.
          setState(() {
            isError = false;
            errorString = '';
          });
        },
      ),
    );

    // Find the Scaffold in the widget tree and use
    // it to show a SnackBar.
    _scaffoldKey.currentState.showSnackBar(snackBar);
    return Container();
  }

  Expanded getLoader() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
