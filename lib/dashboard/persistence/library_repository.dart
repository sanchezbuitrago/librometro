import 'package:librometro/core/services/local_storage.dart';
import 'package:librometro/dashboard/domain/models/books.dart';

class LibraryRepository {

  static final LibraryRepository _instance = LibraryRepository._internal();
  LibraryRepository._internal();
  factory LibraryRepository() {
    return _instance;
  }
  SecureStorage secureStorage = SecureStorage();

  Future<Library> getLibrary() async {
    Map<String, dynamic>? libraryInStorage = await secureStorage.get(SecureStorageKey.library);
    print(libraryInStorage);
    return libraryInStorage == null || libraryInStorage.isEmpty ? Library() : Library.fromMap(libraryInStorage);
  }

  Future<void> saveLibrary(Library library) async {
    await secureStorage.save(SecureStorageKey.library, library.toMap());
  }
}

