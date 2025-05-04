import 'dart:io';

import 'package:flutter/material.dart';
import 'package:librometro/dashboard/domain/models/books.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final Function goToTimer;

  const BookCard({super.key, required this.book, required this.goToTimer});

  String formatDuration(Duration duration) {
    final int hours = duration.inHours;
    final int minutes = duration.inMinutes % 60;
    final int seconds = duration.inSeconds % 60;

    final List<String> parts = <String>[];

    if (hours > 0) parts.add("${hours}h");
    if (minutes > 0) parts.add("$minutes min");
    if (seconds > 0 || parts.isEmpty) parts.add("$seconds seg");

    return parts.join(" ");
  }

  @override
  Widget build(BuildContext context) {
    Widget imageLoaderPlaceholder() {
      return Container(
        width: 100,
        height: 100,
        alignment: Alignment.center,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }

    Widget imageErrorPlaceholder() {
      return Container(
        width: 100,
        height: 100,
        color: Colors.grey[300],
        alignment: Alignment.center,
        child: Icon(Icons.broken_image, color: Colors.grey),
      );
    }

    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.1),
              spreadRadius: 5,
              blurRadius: 5,
              offset: Offset(0, 4),
            ),
          ],
        ),
        margin: EdgeInsets.all(10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child:
                  book.localImage != null
                      ? FutureBuilder(
                        future: File(book.localImage!).exists(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return imageLoaderPlaceholder();
                          } else if (snapshot.hasData &&
                              snapshot.data == true) {
                            return Image.file(
                              File(book.localImage!),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            );
                          } else {
                            return imageLoaderPlaceholder(); // fallback si no existe
                          }
                        },
                      )
                      : Image.network(
                        book.imageUrl,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return imageLoaderPlaceholder();
                        },
                        errorBuilder:
                            (context, error, stackTrace) =>
                                imageErrorPlaceholder(),
                      ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Center(
                            child: Text(
                              book.name,
                              style: TextStyle(color: Colors.white),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      "Total de paginas: ${book.totalPages}",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Última pagina leida: ${book.lastPageRead}",
                      style: TextStyle(color: Colors.white),
                    ),
                    Text(
                      "Tiempo de Lectura: ${formatDuration(book.readingTime)}",
                      style: TextStyle(color: Colors.white),
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: LinearProgressIndicator(
                            value: book.readingPercentage / 100,
                            minHeight: 5,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Text("${book.readingPercentage.toStringAsFixed(1)}%"),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              goToTimer();
                            },
                            child: Text(
                              "Empezar a leer",
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
