import 'dart:io';

import 'package:bookz/constants.dart';
import 'package:bookz/models/Books.dart';
import 'package:bookz/screens/epubViewer/epub_viewer.dart';
import 'package:bookz/screens/search/search_screen.dart';
import 'package:bookz/services/bookSharedPreference.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class DownloadBooksViewer extends StatefulWidget {
  DownloadBooksViewer({Key key}) : super(key: key);

  @override
  _DownloadBooksViewerState createState() => _DownloadBooksViewerState();
}

class _DownloadBooksViewerState extends State<DownloadBooksViewer> {
  List<Books> books = [];

  @override
  void initState() {
    super.initState();
    getDownloadedBooks();
  }

  getDownloadedBooks() async {
    var store = StoreBooksData();
    bool isDownloadsExist = await store.isKeyExists('downloads');
    List<Books> decodedBooks = [];
    String storedEncodedData;
    // check if the key exits in store
    if (isDownloadsExist) {
      storedEncodedData = await store.getStringValuesSF('downloads');
      decodedBooks = Books.decodeBooks(storedEncodedData);
      setState(() {
        books = decodedBooks;
      });
      print(books.length);
    }
  }

  deleteBook(String id, String path) async {
    var store = StoreBooksData();
    bool isDownloadsExist = await store.isKeyExists('downloads');
    List<Books> decodedBooks = [];
    String storedEncodedData;
    String encodedBooksData;

    // check if the key exits in store
    if (isDownloadsExist) {
      storedEncodedData = await store.getStringValuesSF('downloads');
      decodedBooks = Books.decodeBooks(storedEncodedData);
      decodedBooks.removeWhere((book) => book.id == id);
      print(decodedBooks.length);
      File file = File(path);
      await file.delete();
    }

    setState(() {
      books = decodedBooks;
    });
    // storing updated data
    encodedBooksData = Books.encodeBooks(books);
    store.addStringToSF('downloads', encodedBooksData);
  }

  listIncludes(String ext) {
    var acceptedExt = ['epub', 'pdf'];
    return acceptedExt.indexOf(ext) != -1;
  }

  Row getRowData(BuildContext context, Books book) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 15.0,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: FadeInImage.assetNetwork(
                image: book.img,
                placeholder: 'assets/images/placeholder-book.jpg',
                width: 120,
                height: 160,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 15,
                ),
                SizedBox(
                  width: 170,
                  child: Text(
                    book.title,
                    style: GoogleFonts.montserrat(
                      textStyle: TextStyle(
                        letterSpacing: kLetterSpacing,
                        fontWeight: FontWeight.bold,
                        fontSize: kPrimaryFontSize,
                        color: kTextLightColor,
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
                    book.author,
                    style: GoogleFonts.lato(
                      textStyle: TextStyle(
                        letterSpacing: kLetterSpacing,
                        color: kTextColor,
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
                  children: [
                    SizedBox(
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: RaisedButton(
                          color: Colors.orange[100],
                          child: Text(
                            'view',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.black45,
                                  letterSpacing: kLetterSpacing),
                            ),
                          ),
                          onPressed: () {
                            var encodedTitle = book.title
                                .toString()
                                .trim()
                                .replaceAll(new RegExp(r"[^\s\w]"), '');

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EpubBookViewer(
                                  url: book.url,
                                  bookName: encodedTitle,
                                  extension: book.extension,
                                  author: book.author,
                                  title: book.title,
                                  img: book.img,
                                  id: book.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    SizedBox(
                      width: 80,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: RaisedButton(
                          color: Colors.red[100],
                          child: Text(
                            'delete',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(
                                  color: Colors.black45,
                                  letterSpacing: kLetterSpacing),
                            ),
                          ),
                          onPressed: () {
                            // delte the download
                            print('deleting book..');
                            deleteBook(book.id, book.path);
                          },
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: SvgPicture.asset('assets/icons/back.svg'),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text(
        'Downloads',
        style: GoogleFonts.montserrat(
          textStyle:
              TextStyle(color: Colors.white38, letterSpacing: kLetterSpacing),
        ),
      ),
      actions: <Widget>[
        IconButton(
          icon: SvgPicture.asset(
            'assets/icons/search.svg',
            color: kTextColor,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchBar(),
            ),
          ),
        ),
        SizedBox(
          width: kDefaultPaddin / 5,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: buildAppBar(context),
      body: Container(
        child: SafeArea(
          child: books.length > 0
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListView.separated(
                    separatorBuilder: (BuildContext context, int index) {
                      return SizedBox(
                        height: 40,
                        child: Divider(
                          color: kTextColor,
                        ),
                      );
                    },
                    itemCount: books.length,
                    itemBuilder: (context, index) {
                      return getRowData(
                        context,
                        books[index],
                      );
                    },
                  ),
                )
              : Center(
                  child: Text(
                    'There are no downloads, download some books!',
                    style: TextStyle(
                      letterSpacing: kLetterSpacing,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
