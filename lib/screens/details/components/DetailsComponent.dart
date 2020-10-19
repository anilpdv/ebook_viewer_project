import 'package:bookz/constants.dart';
import 'package:bookz/screens/epubViewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class DetailsComponent extends StatelessWidget {
  final book;
  const DetailsComponent({Key key, this.book}) : super(key: key);

  convertBits(String a) {
    var filesize;

    // : if a contains any alphabet return
    if (a.contains(new RegExp(r'[A-Z]'))) {
      return a;
    }

    // : if not convert the bits to human readable string
    var bitnumber = double.parse(a);

    if (bitnumber % 1048576 > 0) {
      filesize = (bitnumber / 1048576).toStringAsFixed(2) + "MB";
    } else if (bitnumber % 1024 > 0) {
      filesize = (bitnumber / 1024).toStringAsFixed(2) + "KB";
    } else {
      filesize = bitnumber.toStringAsFixed(2) + "Bytes";
    }

    return filesize;
  }

  // : get encoded uri
  String getEncodedUri() {
    var encodedTitle = Uri.encodeFull(book['title'] + '-' + book['id']);
    var convertId = (double.parse(book['id']) / 1000).floor() * 1000;
    var md5 = book['md5'] != null ? book['md5'].toString().toLowerCase() : '';

    var uri = kDownloadUrl +
        convertId.toString() +
        '/' +
        md5 +
        '/' +
        encodedTitle +
        '.' +
        book['extension'];

    var encodedUri = Uri.encodeFull(uri);
    return encodedUri;
  }

  listIncludes(String ext) {
    var acceptedExt = ['epub', 'pdf'];
    return acceptedExt.indexOf(ext) != -1;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          children: [
            Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 15.0,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Image.network(
                        kConverUrl + book['coverurl'],
                        width: 200,
                        height: 250,
                        fit: BoxFit.fill,
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
                        RatingBarIndicator(
                          itemPadding: EdgeInsets.all(0.0),
                          itemSize: 20.0,
                          rating: 5.0,
                          itemBuilder: (context, index) {
                            return Icon(
                              Icons.star,
                              color: Colors.amber,
                            );
                          },
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        SizedBox(
                          width: 170,
                          child: Text(
                            book["title"],
                            style: TextStyle(
                              letterSpacing: kLetterSpacing,
                              fontWeight: FontWeight.bold,
                              fontSize: kPrimaryFontSize,
                              color: kTextColor,
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
                            style: TextStyle(
                              letterSpacing: kLetterSpacing,
                              color: kTextLightColor,
                              fontSize: kSecondaryFontSize,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              convertBits(book['filesize']),
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
                              child: RaisedButton(
                                color: Colors.grey[350],
                                child: Text(
                                  book['extension'],
                                  style: TextStyle(
                                    color: Colors.black45,
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
                          height: 20,
                        ),
                        SizedBox(
                          width: 160,
                          child: listIncludes(book['extension'])
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100.0),
                                  child: RaisedButton(
                                    color: Colors.orangeAccent,
                                    child: Text(
                                      'View',
                                      style: TextStyle(
                                          color: Colors.black45,
                                          letterSpacing: kLetterSpacing),
                                    ),
                                    onPressed: () {
                                      var encodedTitle = book['title']
                                          .toString()
                                          .trim()
                                          .replaceAll(
                                              new RegExp(r"[^\s\w]"), '');

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EpubBookViewer(
                                            url: getEncodedUri(),
                                            bookName: encodedTitle,
                                            extension: book['extension'],
                                          ),
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
                                            color: kTextLightColor,
                                            fontSize: 10),
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
            ),
            Divider(
              height: 50,
            ),
            getDescription(),
          ],
        ),
      ),
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
            book['descr'] != null ? "About" : '',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              letterSpacing: kLetterSpacing,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            book['descr'] != null ? book['descr'] : '',
            style: TextStyle(
              fontSize: 16,
              letterSpacing: kLetterSpacing,
              height: 2,
            ),
            textAlign: TextAlign.justify,
          )
        ],
      )),
    );
  }
}
