import 'package:bookz/models/BookRatings.dart';
import 'package:bookz/screens/details/components/DetailsComponent.dart';
import 'package:bookz/screens/downloads/downloads_screen.dart';
import 'package:bookz/screens/search/search_screen.dart';
import 'package:bookz/services/bookService.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookz/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatefulWidget {
  final book;

  const DetailsScreen({Key key, this.book}) : super(key: key);

  @override
  _DetailsScreenState createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  var rating;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    setBookRating();
  }

  setBookRating() async {
    String isbn = '';
    BookRatings bookRatings;

    if (widget.book['identifier'] != null) {
      isbn = widget.book['identifier'].split(',')[0];
      BooksService booksService = BooksService();
      setState(() {
        loading = true;
      });
      try {
        bookRatings = await booksService.getBookRatings(isbn);
        setState(() {
          if (bookRatings?.books[0]?.averageRating != null) {
            rating = bookRatings.books[0].averageRating;
          }
        });
      } catch (err) {
        setState(() {
          loading = false;
        });
        print(err);
      }
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(widget.book['identifier'].split(',')[0]);
    return Scaffold(
      // each product have a color
      appBar: buildAppBar(context),
      body: getBody(),
    );
  }

  Column getBody() {
    return Column(
      children: [
        !loading
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DetailsComponent(book: widget.book, rating: rating),
                ),
              )
            : Container(),
        loading ? getLoader() : Container()
      ],
    );
  }

  Expanded getLoader() {
    return Expanded(
      child: Center(
        child: CircularProgressIndicator(
          backgroundColor: Colors.black,
        ),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        'Details',
        style: GoogleFonts.montserrat(
          textStyle:
              TextStyle(color: kTextColor, letterSpacing: kLetterSpacing),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset(
          'assets/icons/back.svg',
          color: Colors.black,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            "assets/icons/search.svg",
            color: kTextColor,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchBar(),
            ),
          ),
        ),
        SizedBox(width: kDefaultPaddin / 2),
        IconButton(
          icon: Icon(
            Icons.download_sharp,
            color: kTextColor,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DownloadBooksViewer(),
            ),
          ),
        ),
        SizedBox(
          width: kDefaultPaddin / 2,
        ),
      ],
    );
  }
}
