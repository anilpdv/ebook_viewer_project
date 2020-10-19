import 'package:bookz/constants.dart';
import 'package:bookz/screens/home/components/book_grid.dart';
import 'package:bookz/services/bookService.dart';
import 'package:flutter/material.dart';
import 'package:beauty_textfield/beauty_textfield.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SearchBar extends StatefulWidget {
  SearchBar({Key key}) : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  List books = [];
  bool loader = false;

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
    });

    // creating url to request
    var url = kAPI_URL + kSearchApiUri + '?q=' + query;
    print(url);
    try {
      response = await booksService.getData(url);
    } on Exception catch (e) {
      print(e);
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
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BeautyTextfield(
              width: double.maxFinite,
              height: 60,
              duration: Duration(milliseconds: 300),
              inputType: TextInputType.text,
              prefixIcon: Icon(Icons.search),
              suffixIcon: Icon(Icons.remove_red_eye),
              placeholder: "Search...",
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
            loader ? getLoader() : getBooksGrid()
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

  Center getLoader() {
    return Center(
      child: SpinKitThreeBounce(
        color: Colors.blueAccent,
        size: 25.0,
      ),
    );
  }
}
