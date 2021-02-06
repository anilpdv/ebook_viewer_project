import 'package:bookz/constants.dart';
import 'package:bookz/screens/epubViewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailsComponent extends StatelessWidget {
  final book;
  final rating;
  const DetailsComponent({Key key, this.book, this.rating}) : super(key: key);

  listIncludes(String ext) {
    var acceptedExt = ['epub', 'pdf'];
    return acceptedExt.indexOf(ext) != -1;
  }

  @override
  Widget build(BuildContext context) {
    return buildSingleChildScrollView(context);
  }

  SingleChildScrollView buildSingleChildScrollView(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            getRowData(context),
            Divider(
              height: 50,
            ),
            getDescription(),
          ],
        ),
      ),
    );
  }

  Row getRowData(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: Card(
              elevation: 10.0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6.0),
                child: FadeInImage.assetNetwork(
                  image: kConverUrl + book['coverurl'],
                  placeholder: 'assets/images/placeholder-book.jpg',
                  width: 200,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    RatingBarIndicator(
                      itemPadding: EdgeInsets.all(0.0),
                      itemSize: 20.0,
                      rating: double.parse(rating != null ? rating : '0.0'),
                      itemBuilder: (context, index) {
                        return Icon(
                          Icons.star,
                          color: Colors.amber,
                        );
                      },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      rating != null ? rating : '',
                      style: TextStyle(
                        fontSize: 13,
                        color: kTextLightColor,
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    book["title"],
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        letterSpacing: 1,
                        fontWeight: FontWeight.bold,
                        fontSize: kPrimaryFontSize,
                        color: kTextColor,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 7,
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    book["author"],
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        letterSpacing: kLetterSpacing,
                        color: kTextLightColor,
                        fontSize: kSecondaryFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  children: <Widget>[
                    Text(
                      book['filesize'],
                      style: TextStyle(
                          letterSpacing: kLetterSpacing,
                          color: kTextLightColor,
                          fontSize: kSecondaryFontSize),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      height: 25,
                      child: FlatButton(
                        color: Colors.blue[50],
                        child: Text(
                          book['extension'].toString().toUpperCase(),
                          style: GoogleFonts.lato(
                            textStyle: TextStyle(
                                color: Colors.black45,
                                letterSpacing: kLetterSpacing),
                          ),
                        ),
                        onPressed: () {
                          print('You tapped on RaisedButton');
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                SizedBox(
                  width: 160,
                  child: listIncludes(book['extension'])
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: RaisedButton(
                            color: Colors.orangeAccent,
                            child: Text(
                              'View',
                              style: GoogleFonts.lato(
                                textStyle: TextStyle(
                                    color: Colors.black45,
                                    letterSpacing: kLetterSpacing),
                              ),
                            ),
                            onPressed: () {
                              var encodedTitle = book['title']
                                  .toString()
                                  .trim()
                                  .replaceAll(new RegExp(r"[^\s\w]"), '');

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EpubBookViewer(
                                      url: book['download'],
                                      bookName: encodedTitle,
                                      extension: book['extension'],
                                      author: book['author'],
                                      title: book['title'],
                                      img: kConverUrl + book['coverurl'],
                                      id: book['id'],
                                      locator: book['locator']),
                                ),
                              );
                            },
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Icon(
                                Icons.error,
                                color: Colors.orange[200],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(
                                'you can only view epub and pdf formats.',
                                style: TextStyle(
                                    color: kTextLightColor, fontSize: 10),
                              ),
                            )
                          ],
                        ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  Padding getDescription() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
      child: Container(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            book['descr'] != null && book['descr'].toString().length > 1
                ? "About"
                : '',
            style: GoogleFonts.montserrat(
              textStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                letterSpacing: 2,
              ),
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            book['descr'] != null
                ? book['descr']
                    // ignore: valid_regexps
                    .replaceAll(r'<[^>]*>', " ")
                    .replaceAll(r"\\s+", " ")
                    .trim()
                : '',
            style: GoogleFonts.openSans(
              textStyle: TextStyle(
                fontSize: 16,
                letterSpacing: kLetterSpacing,
                height: 2,
              ),
            ),
            textAlign: TextAlign.justify,
          )
        ],
      )),
    );
  }
}
