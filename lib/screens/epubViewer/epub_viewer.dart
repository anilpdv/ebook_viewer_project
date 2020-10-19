import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookz/constants.dart';
import 'package:dio/dio.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class EpubBookViewer extends StatefulWidget {
  final String url;
  final String bookName;
  final String extension;
  EpubBookViewer(
      {@required this.url, @required this.bookName, @required this.extension});
  @override
  _EpubBookViewerState createState() => _EpubBookViewerState();
}

class _EpubBookViewerState extends State<EpubBookViewer> {
  bool loading = true;
  int currentStep = 0;
  String bookPath = '';
  Dio dio = new Dio();

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
              ? InvokeEpup(bookPath: bookPath)
              : widget.extension == 'pdf'
                  ? PDFScreen(
                      path: bookPath,
                      bookName: widget.bookName,
                    )
                  : Container(),
    );
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
    print(widget.bookName);
    print(widget.url);
    String path =
        appDocDir.path + '/' + widget.bookName + '.' + widget.extension;
    setState(() {
      bookPath = path;
    });
    print(path);
    File file = File(path);

    if (!File(path).existsSync()) {
      await file.create();
      await dio.download(
        widget.url,
        path,
        deleteOnError: true,
        onReceiveProgress: (receivedBytes, totalBytes) {
          // setting percentage
          setState(() {
            currentStep = int.parse(
                (receivedBytes / totalBytes * 100).toStringAsFixed(0));
          });
          //Check if download is complete and close the alert dialog
          if (receivedBytes == totalBytes) {
            setState(() {
              loading = false;
            });
          }
        },
      );
    } else {
      setState(() {
        loading = false;
      });
    }
  }
}

class InvokeEpup extends StatefulWidget {
  const InvokeEpup({
    Key key,
    @required this.bookPath,
  }) : super(key: key);

  final String bookPath;

  @override
  _InvokeEpupState createState() => _InvokeEpupState();
}

class _InvokeEpupState extends State<InvokeEpup> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, this.invokeEpub);
  }

  invokeEpub() {
    EpubViewer.setConfig(
      themeColor: Theme.of(context).primaryColor,
      identifier: "iosBook",
      scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
      allowSharing: true,
      enableTts: true,
    );
    EpubViewer.open(
      widget.bookPath,
    );

    // get current locator
    EpubViewer.locatorStream.listen((locator) {
      print('LOCATOR: ${EpubLocator.fromJson(jsonDecode(locator))}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class PDFScreen extends StatefulWidget {
  final String path;
  final String bookName;

  PDFScreen({Key key, this.path, this.bookName}) : super(key: key);

  _PDFScreenState createState() => _PDFScreenState();
}

class _PDFScreenState extends State<PDFScreen> with WidgetsBindingObserver {
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.bookName),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          PDFView(
            filePath: widget.path,
            enableSwipe: true,
            autoSpacing: false,
            pageFling: true,
            pageSnap: true,
            defaultPage: currentPage,
            fitPolicy: FitPolicy.BOTH,
            preventLinkNavigation:
                false, // if set to true the link is handled in flutter
            onRender: (_pages) {
              setState(() {
                pages = _pages;
                isReady = true;
              });
            },
            onError: (error) {
              setState(() {
                errorMessage = error.toString();
              });
              print(error.toString());
            },
            onPageError: (page, error) {
              setState(() {
                errorMessage = '$page: ${error.toString()}';
              });
              print('$page: ${error.toString()}');
            },
            onViewCreated: (PDFViewController pdfViewController) {
              _controller.complete(pdfViewController);
            },
            onLinkHandler: (String uri) {
              print('goto uri: $uri');
            },
            onPageChanged: (int page, int total) {
              print('page change: $page/$total');
              setState(() {
                currentPage = page;
              });
            },
          ),
          errorMessage.isEmpty
              ? !isReady
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container()
              : Center(
                  child: Text(errorMessage),
                )
        ],
      ),
      floatingActionButton: FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton.extended(
              label: Text("Go to ${pages ~/ 2}"),
              onPressed: () async {
                await snapshot.data.setPage(pages ~/ 2);
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
