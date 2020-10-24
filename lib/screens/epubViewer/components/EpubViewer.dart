import 'dart:convert';

import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';

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
