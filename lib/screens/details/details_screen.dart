import 'package:bookz/screens/details/components/DetailsComponent.dart';
import 'package:bookz/screens/downloads/downloads_screen.dart';
import 'package:bookz/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:bookz/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsScreen extends StatelessWidget {
  final book;

  const DetailsScreen({Key key, this.book}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // each product have a color
      appBar: buildAppBar(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: DetailsComponent(book: book),
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
