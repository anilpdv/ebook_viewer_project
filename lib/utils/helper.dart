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
String getEncodedUri(book, reqData) {
  var encodedTitle = Uri.encodeFull(book['title'] + '-' + book['id']);
  var convertId = (double.parse(book['id']) / 1000).floor() * 1000;
  var md5 = book['md5'] != null ? book['md5'].toString().toLowerCase() : '';

  var uri = reqData['durl'] +
      '/' +
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
