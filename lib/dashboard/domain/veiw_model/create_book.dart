import 'package:librometro/dashboard/domain/models/events.dart';
import 'package:librometro/dashboard/domain/services/library.dart';

class CreateBookViewModel{
  LibraryController libraryController = LibraryController();
  CreateBookViewModel();

  Future<LibraryEvent> createBook(String name, int totalPages, String? filePath) async {
    libraryController.createBook(name, totalPages, filePath);
    return BookCreated();
  }

}