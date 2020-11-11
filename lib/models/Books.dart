import 'dart:convert';

class Books {
  final String id, filesize, author, title, img, extension, path, bookName, url;
  String locator;

  Books({
    this.id,
    this.title,
    this.filesize,
    this.img,
    this.author,
    this.extension,
    this.path,
    this.bookName,
    this.url,
    this.locator,
  });

  String get locater_obj {
    return locator;
  }

  set locator_obj(String location) {
    this.locator = location;
  }

  factory Books.fromJson(Map<String, dynamic> jsonData) {
    return Books(
      id: jsonData['id'],
      title: jsonData['title'],
      filesize: jsonData['filesize'],
      img: jsonData['img'],
      author: jsonData['author'],
      extension: jsonData['extension'],
      path: jsonData['path'],
      bookName: jsonData['bookName'],
      url: jsonData['url'],
      locator: jsonData['locator'],
    );
  }

  static Map<String, dynamic> toMap(Books book) => {
        'id': book.id,
        'title': book.title,
        'img': book.img,
        'filesize': book.filesize,
        'author': book.author,
        'extension': book.extension,
        'path': book.path,
        'bookName': book.bookName,
        'url': book.url,
        'locator': book.locator
      };

  static String encodeBooks(List<Books> books) => json.encode(
        books.map<Map<String, dynamic>>((book) => Books.toMap(book)).toList(),
      );

  static List<Books> decodeBooks(String books) =>
      (json.decode(books) as List<dynamic>)
          .map<Books>((item) => Books.fromJson(item))
          .toList();
}
