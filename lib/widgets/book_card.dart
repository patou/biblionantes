import 'package:biblionantes/models/book.dart';
import 'package:flutter/material.dart';

class BookCard extends StatelessWidget {
  final Book book;

  const BookCard({Key? key, required this.book})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      padding: const EdgeInsets.all(10),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 150,
            child: Image.network(
              book.imageURL,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.title,
                  overflow: TextOverflow.fade,
                  maxLines: 5,
                ),
                if (book.creators != null)
                  Text(book.creators!, softWrap: false, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey, fontSize: 12),),
                Spacer(),
                Text(book.type),
                if (book.available != null)
                  available(book.available!)
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget available(bool available) {
    return Text(available ? 'Disponible' : 'Non disponible', style: TextStyle(color: available ? Colors.green : Colors.red),);
  }
}
