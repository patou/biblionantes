import 'package:biblionantes/models/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Widget? widget;
  final bool useBoxShadow;

  const BookCard({Key? key, required this.book, this.widget, this.useBoxShadow = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          if (useBoxShadow == true)
            BoxShadow(color: Colors.grey, offset: const Offset(0.0, 1.0), blurRadius: 6.0),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            child: book.imageURL != null ? Image.network(
              book.imageURL!,
            ) : Icon(Icons.book),
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
                  Text(book.creators!, softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontSize: 12, ),),
                Spacer(),
                if (book.type != null)
                  Text(book.type!, textAlign: TextAlign.right,),
                if (widget != null)
                  widget!,
              ],
            ),
          )
        ],
      ),
    );
  }
}
