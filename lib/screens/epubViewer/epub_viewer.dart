import 'dart:async';
import 'dart:io';
import 'dart:convert';

import 'package:bookz/constants.dart';
import 'package:bookz/helpers/database_helper.dart';
import 'package:bookz/models/Books.dart';
import 'package:bookz/screens/epubViewer/components/pdfViewer.dart';
import 'package:bookz/services/bookSharedPreference.dart';
import 'package:dio/dio.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class EpubBookViewer extends StatefulWidget {
  final String url;
  final String bookName;
  final String extension;
  final String author;
  final String img;
  final String title;
  final String id;
  final String locator;

  EpubBookViewer(
      {@required this.url,
      @required this.bookName,
      @required this.extension,
      @required this.author,
      @required this.img,
      @required this.title,
      @required this.id,
      this.locator});

  @override
  _EpubBookViewerState createState() => _EpubBookViewerState();
}

class _EpubBookViewerState extends State<EpubBookViewer> {
  bool loading = true;
  int currentStep = 0;
  String bookPath = '';
  Dio dio = new Dio();
  bool downloaded = false;

  @override
  void initState() {
    super.initState();
    download();
  }

  download() async {
    if (Platform.isAndroid || Platform.isIOS) {
      setState(() {
        loading = true;
      });
      print('download');
      await downloadFile();
    } else {
      loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularStepProgressIndicator(
                    totalSteps: 100,
                    currentStep: currentStep,
                    stepSize: 5,
                    selectedColor: Colors.greenAccent,
                    unselectedColor: Colors.grey[200],
                    padding: 0,
                    width: 150,
                    height: 150,
                    selectedStepSize: 8,
                    roundedCap: (_, __) => true,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      currentStep.toString() + ' ' + '%',
                      style: TextStyle(
                          color: kTextLightColor, fontSize: kSecondaryFontSize),
                    ),
                  )
                ],
              ),
            )
          : widget.extension == 'epub'
              ? invokeEpub()
              : widget.extension == 'pdf'
                  ? PDFScreen(
                      path: bookPath,
                      bookName: widget.bookName,
                    )
                  : Offstage(),
    );
  }

  invokeEpub() {
    if (downloaded == true) {
      openBook();
    }
  }

  openBook() async {
    List locators = await LocatorDB().getLocator(widget.id.toString());

    EpubViewer.setConfig(
      themeColor: Theme.of(context).accentColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.VERTICAL,
      allowSharing: true,
      enableTts: true,
    );

    EpubViewer.open(bookPath,
        lastLocation:
            locators.isNotEmpty ? EpubLocator.fromJson(locators[0]) : null);

    EpubViewer.locatorStream.listen((event) async {
      // Get locator here
      Map json = jsonDecode(event);
      json['bookId'] = widget.id.toString();
      // Save locator to your database
      await LocatorDB().update(json);
    });
  }

  Future downloadFile() async {
    print('download1');
    PermissionStatus permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted) {
      await [Permission.storage].request();
      await startDownload();
    } else {
      await startDownload();
    }
  }

  startDownload() async {
    Directory appDocDir = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    String path =
        appDocDir.path + '/' + widget.bookName + '.' + widget.extension;
    setState(() {
      bookPath = path;
    });
    print(path);
    File file = File(path);
    print(widget.url);
    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        widget.url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) async {
          // setting percentage
          setState(() {
            currentStep = int.parse(
                (receivedBytes / totalBytes * 100).toStringAsFixed(0));
          });
          //Check if download is complete and close the alert dialog
          if (receivedBytes == totalBytes) {
            await setBooksInSharedPreference();
            setState(() {
              loading = false;
              downloaded = true;
            });
          }
        },
      );
    } else {
      setState(() {
        loading = false;
        downloaded = true;
      });
    }
  }

  setBooksInSharedPreference() async {
    var store = StoreBooksData();
    bool isDownloadsExist = await store.isKeyExists('downloads');
    List<Books> books = [];
    String storedEncodedData;
    String encodedBooksData;

    // check if the key exits in store
    if (isDownloadsExist) {
      storedEncodedData = await store.getStringValuesSF('downloads');
      books = Books.decodeBooks(storedEncodedData);

      books.add(
        Books(
          author: widget.author,
          title: widget.title,
          img: widget.img,
          path: bookPath,
          bookName: widget.bookName,
          url: widget.url,
          extension: widget.extension,
          id: widget.id,
        ),
      );
    } else {
      books.add(
        Books(
          author: widget.author,
          title: widget.title,
          img: widget.img,
          path: bookPath,
          bookName: widget.bookName,
          url: widget.url,
          extension: widget.extension,
          id: widget.id,
        ),
      );
    }

    // storing updated data
    encodedBooksData = Books.encodeBooks(books);
    store.addStringToSF('downloads', encodedBooksData);
  }
}
