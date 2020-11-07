import 'package:flutter/material.dart';

const kTextColor = Color(0xFF535353);
const kTextLightColor = Color(0xFFACACAC);
const kLetterSpacing = 0.8;
const kPrimaryFontSize = 14.0;
const kSecondaryFontSize = 12.0;

const kDefaultPaddin = 20.0;
const kRatingApiKey = "WL3kZbSi6A4J0XFcBuTmg";

const kAPI_URL = 'https://desolate-harbor-02759.herokuapp.com';
const kDownloadUrl = 'http://87.120.36.5/main/';
const kSearchApiUri = '/api/books/search';
const kDownloadUri = '/api/books/downloadUrl';

const kLATEST_URL =
    'http://libgen.rs/json.php?fields=id,title,author,filesize,extension,md5,coverurl,descr,identifier&mode=last&limit1=20';
const kConverUrl = 'http://libgen.rs/covers/';

const kDefaultImage =
    'https://www.katjakettu.com/wp-content/uploads/placeholder-book-300x400.jpg';
const kRatingsApi =
    'https://www.goodreads.com/book/review_counts.json?key=$kRatingApiKey&isbns=';

var kRegex = new RegExp(r'bgcolor.+<td>(\d+)<\/td>');
