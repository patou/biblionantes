import 'package:biblionantes/models/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Widget? widget;
  final bool useBoxShadow;
  final bool isSelected;
  final bool isSelectedMode;

  const BookCard(
      {Key? key,
      required this.book,
      this.widget,
      this.useBoxShadow = true,
      this.isSelected = false,
      this.isSelectedMode = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blueAccent.withOpacity(0.01) : Colors.white,
        boxShadow: [
          if (useBoxShadow == true)
            BoxShadow(
                color: Colors.grey,
                offset: const Offset(0.0, 1.0),
                blurRadius: 6.0),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Stack(
              alignment: Alignment.center,
              children: [
                book.imageURL != null
                    ? Image.network(
                        book.imageURL!,
                      )
                    : Icon(Icons.book),
                if (this.isSelectedMode)
                  Positioned(
                      top: 5,
                      left: 5,
                      child: Icon(this.isSelected
                          ? Icons.check_box_rounded
                          : Icons.check_box_outline_blank_rounded))
              ],
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
                if (book.creators != null)
                  Text(
                    book.creators!,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                Spacer(),
                if (book.type != null)
                  Text(
                    book.type!,
                    textAlign: TextAlign.right,
                  ),
                if (widget != null) widget!,
              ],
            ),
          )
        ],
      ),
    );
  }
}
