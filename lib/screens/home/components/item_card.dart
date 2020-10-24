import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class ItemCard extends StatelessWidget {
  final book;
  final Function press;

  const ItemCard({Key key, this.book, this.press}) : super(key: key);

  checkStringLenghth(String title) {
    if (title != null && title.length > 30) {
      return title.substring(0, 30) + '....';
    }
    return title;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: press,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 200,
            width: 200,
            padding: EdgeInsets.all(kDefaultPaddin),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(16),
            ),
            child: FadeInImage(
              image: NetworkImage(
                'http://libgen.rs/covers/${book["coverurl"]}',
              ),
              placeholder: NetworkImage(kDefaultImage),
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: kDefaultPaddin / 2, horizontal: kDefaultPaddin / 2),
            child: Text(
              checkStringLenghth(book["title"]),
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    letterSpacing: kLetterSpacing,
                    fontWeight: FontWeight.bold,
                    fontSize: kPrimaryFontSize),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin / 2),
            child: Text(
              checkStringLenghth('${book["author"]}'),
              style: GoogleFonts.lato(
                textStyle: TextStyle(
                    color: kTextLightColor,
                    letterSpacing: kLetterSpacing,
                    fontSize: kSecondaryFontSize),
              ),
            ),
          )
        ],
      ),
    );
  }
}
