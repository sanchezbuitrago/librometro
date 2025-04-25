import 'package:flutter/material.dart';
import 'package:librometro/dashboard/domain/models/books.dart';

class BookCard extends StatelessWidget {
  final Book book;
  const BookCard({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(
              'https://images.cdn2.buscalibre.com/fit-in/360x360/67/2e/672ee81ffd4909a069d4bbcfeeecfe0e.jpg',
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 10), // Separación horizontal
          Expanded(
            child: SizedBox(
              height: 100,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    book.name,
                    style: TextStyle(color: Colors.white),
                  ),
                  Text(
                    "Pages: ${book.totalPages}",
                    style: TextStyle(color: Colors.white),
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: LinearProgressIndicator(
                          value: 0.5,
                          minHeight: 5,
                          backgroundColor: Colors.grey[300],
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Text("${(book.readingPages * 100 / book.totalPages).toString()}%"),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
