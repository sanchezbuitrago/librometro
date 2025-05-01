import 'package:librometro/dashboard/persistence/library_repository.dart';
import 'package:librometro/dashboard/domain/models/books.dart';

class LibraryController {

  static final LibraryController _instance = LibraryController._internal();
  LibraryController._internal();
  factory LibraryController() {
    return _instance;
  }
  LibraryRepository libraryRepository = LibraryRepository();

  Future<Duration> getReadingTime() async {
    Library library = await libraryRepository.getLibrary();
    return library.totalReadingTime;
  }

  Future<int> getReadingPages() async {
    Library library = await libraryRepository.getLibrary();
    return library.totalReadingPages;
  }

  Future<List<Book>> getInProgressBooks() async {
    Library library = await libraryRepository.getLibrary();
    return library.inProcessBooks;
  }

  Future<List<Book>> getFinalizedBooks() async {
    Library library = await libraryRepository.getLibrary();
    return library.finalizedBooks;
  }

  Future<List<Book>> getPendingBooks() async {
    Library library = await libraryRepository.getLibrary();
    return library.pendingBooks;
  }

  Future<Book> createBook(String name, int totalPages, String? filePath) async {
    Library library = await libraryRepository.getLibrary();
    Book newBook = Book(name: name, totalPages: totalPages, localImage: filePath);
    library.addBookToPendingList(newBook);
    libraryRepository.saveLibrary(library);
    return newBook;
  }
}

