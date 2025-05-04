import 'package:librometro/dashboard/domain/services/library.dart';

class TimerViewModel {
  LibraryController libraryController = LibraryController();
  Future<void> addReadingTimeToBook(String id, Duration readingTime, int lastReadPage) async {
    await libraryController.addReadingTime(id, readingTime, lastReadPage);
  }
}