import 'package:flutter/material.dart';

import '../../../constants.dart';

class ItemCard extends StatelessWidget {
  final book;
  final Function press;

  const ItemCard({Key key, this.book, this.press}) : super(key: key);

  checkStringLenghth(String title) {
    if (title != null && title.length > 40) {
      return title.substring(0, 40) + '....';
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
            child: Image(
              image: NetworkImage(
                'http://libgen.rs/covers/${book["coverurl"]}',
              ),
              fit: BoxFit.fill,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: kDefaultPaddin / 4),
            child: Text(
              checkStringLenghth(book["title"]),
              style: TextStyle(
                letterSpacing: kLetterSpacing,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(
            checkStringLenghth('${book["author"]}'),
            style: TextStyle(
              color: kTextLightColor,
              letterSpacing: kLetterSpacing,
            ),
          )
        ],
      ),
    );
  }
}
