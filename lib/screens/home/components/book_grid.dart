import 'package:bookz/constants.dart';
import 'package:bookz/screens/details/details_screen.dart';
import 'package:bookz/screens/home/components/item_card.dart';
import 'package:flutter/material.dart';

class BooksGrid extends StatelessWidget {
  const BooksGrid({
    Key key,
    @required this.books,
  }) : super(key: key);

  final List books;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kDefaultPaddin),
        child: GridView.builder(
          itemCount: books != null ? books.length : 0,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: kDefaultPaddin,
            crossAxisSpacing: kDefaultPaddin,
            childAspectRatio: 0.55,
          ),
          itemBuilder: (context, index) => ItemCard(
            book: books[index],
            press: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailsScreen(
                  book: books[index],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
