import 'package:librometro/dashboard/domain/models/events.dart';
import 'package:librometro/dashboard/domain/models/books.dart';
import 'package:librometro/dashboard/domain/services/library.dart';

class DashboardViewModel{
  LibraryController libraryController = LibraryController();
  DashboardViewModel();

  Future<LibraryEvent> getStatistics() async {
    List<Book> inProgressBooks = await libraryController.getInProgressBooks();
    List<Book> pendingBooks = await libraryController.getPendingBooks();
    List<Book> finalizedBooks = await libraryController.getFinalizedBooks();
    int readingPages = await libraryController.getReadingPages();
    Duration readingTime = await libraryController.getReadingTime();
    return LibraryStatisticsConsulted(
      pendingBooks: pendingBooks,
      finalizeBooks: finalizedBooks,
      inProgressBooks: inProgressBooks,
      pagesMerMinute: readingTime.inMinutes != 0 && readingPages !=0 ? readingTime.inMinutes / readingPages : 0,
      readingHours: readingTime.inHours
    );
  }

}