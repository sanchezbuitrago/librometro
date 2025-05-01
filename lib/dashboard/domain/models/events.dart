import 'package:librometro/dashboard/domain/models/books.dart';

class LibraryEvent {}

class LibraryStatisticsConsulted extends LibraryEvent {
  List<Book> inProgressBooks;
  List<Book> pendingBooks;
  List<Book> finalizeBooks;
  int readingHours;
  double pagesMerMinute;

  LibraryStatisticsConsulted({required this.pendingBooks, required this.finalizeBooks, required this.inProgressBooks, required this.pagesMerMinute, required this.readingHours});

}


class BookCreated extends LibraryEvent {
  BookCreated();
}