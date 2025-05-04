import 'package:librometro/dashboard/domain/models/exeptions.dart';

class Library {
  List<Book> pendingBooks;
  List<Book> inProcessBooks;
  List<Book> finalizedBooks;
  Duration totalReadingTime;
  int totalReadingPages;

  Library({
    List<Book>? pendingBooks,
    List<Book>? finalizedBooks,
    List<Book>? inProcessBooks,
    Duration? totalReadingTime,
    int? totalReadingPages,
  }) : pendingBooks = pendingBooks ?? [],
       finalizedBooks = finalizedBooks ?? [],
       inProcessBooks = inProcessBooks ?? [],
       totalReadingTime = totalReadingTime ?? Duration(),
       totalReadingPages = totalReadingPages ?? 0 {

    List<Book> totalBooks = [];
    totalBooks.addAll(this.inProcessBooks);
    totalBooks.addAll(this.pendingBooks);
    totalBooks.addAll(this.finalizedBooks);

    int totalPages = 0;
    int totalTime = 0;
    for(int i=0; i<totalBooks.length;i++){
      totalTime = totalTime + totalBooks[i].readingTime.inMilliseconds;
      totalPages = totalPages + totalBooks[i].lastPageRead;
    }
    this.totalReadingPages = totalPages;
    this.totalReadingTime = Duration(milliseconds: totalTime);

  }

  Book? _findBookInInProgressList(String id){
    for(int i=0;i < inProcessBooks.length; i++){
      if(inProcessBooks[i].id == id){
        return inProcessBooks[i];
      }
    }
    return null;
  }

  Book? _findBookInPendingList(String id){
    for(int i=0;i < pendingBooks.length; i++){
      if(pendingBooks[i].id == id){
        return pendingBooks[i];
      }
    }
    return null;
  }


  Book? _findBookInFinalizedList(String id){
    for(int i=0;i < finalizedBooks.length; i++){
      if(finalizedBooks[i].id == id){
        return finalizedBooks[i];
      }
    }
    return null;
  }


  void addReadingEventToBook(String id, Duration readingTime, int lastReadPage){
    Book? book;
    book = _findBookInFinalizedList(id);
    if( book != null){
      throw BookAlreadyFinalized();
    }

    book = _findBookInInProgressList(id);
    if(book != null){
      book.addReadingEvent(ReadingEvent(readingDate: DateTime.now(), readingTime: readingTime, lastPageRead: lastReadPage));
    }

    book = _findBookInPendingList(id);
    if(book != null){
      pendingBooks.remove(book);
      inProcessBooks.add(book);
      book.addReadingEvent(ReadingEvent(readingDate: DateTime.now(), readingTime: readingTime, lastPageRead: lastReadPage));
    }
  }

  static Library fromMap(Map<String, dynamic> map) {
    List<Book> pendingBook = [];
    List<dynamic> pendingBooksMap = map["pendingBooks"];
    for (int i = 0; i < pendingBooksMap.length; i++) {
      pendingBook.add(Book.fromMap(pendingBooksMap[i]));
    }

    List<Book> inProcessBooks = [];
    List<dynamic> inProcessBooksMap = map["inProcessBooks"];
    for (int i = 0; i < inProcessBooksMap.length; i++) {
      inProcessBooks.add(Book.fromMap(inProcessBooksMap[i]));
    }

    List<Book> finalizedBooks = [];
    List<dynamic> finalizedBooksMap = map["finalizedBooks"];
    for (int i = 0; i < finalizedBooksMap.length; i++) {
      finalizedBooks.add(Book.fromMap(finalizedBooksMap[i]));
    }

    return Library(
      pendingBooks: pendingBook,
      inProcessBooks: inProcessBooks,
      finalizedBooks: finalizedBooks,
      totalReadingPages: int.parse(map["totalReadingPages"]),
      totalReadingTime: Duration(
        milliseconds: int.parse(map["totalReadingTime"]),
      ),
    );
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> finalizedBooksMap = [];
    for (int i = 0; i < finalizedBooks.length; i++) {
      finalizedBooksMap.add(finalizedBooks[i].toMap());
    }

    List<Map<String, dynamic>> inProcessBooksMap = [];
    for (int i = 0; i < inProcessBooks.length; i++) {
      inProcessBooksMap.add(inProcessBooks[i].toMap());
    }

    List<Map<String, dynamic>> pendingBooksMap = [];
    for (int i = 0; i < pendingBooks.length; i++) {
      pendingBooksMap.add(pendingBooks[i].toMap());
    }

    return {
      "pendingBooks": pendingBooksMap,
      "inProcessBooks": inProcessBooksMap,
      "finalizedBooks": finalizedBooksMap,
      "totalReadingTime": totalReadingTime.inMilliseconds.toString(),
      "totalReadingPages": totalReadingPages.toString(),
    };
  }

  void addBookToPendingList(Book book) {
    pendingBooks.add(book);
  }
}

class Book {
  String id;
  String name;
  int totalPages;
  String? localImage;
  String imageUrl;
  double readingPercentage;
  int lastPageRead;
  Duration readingTime;

  List<ReadingEvent> readingEvents;

  Book({
    required this.id,
    required this.name,
    required this.totalPages,
    this.localImage,
    this.imageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png",
    this.readingPercentage = 0,
    this.lastPageRead = 0,
    this.readingTime = const Duration(),
    this.readingEvents = const [],
  });

  void addReadingEvent(ReadingEvent event) {
    lastPageRead = event.lastPageRead;
    readingTime = readingTime + event.readingTime;
    readingPercentage = lastPageRead * 100 / totalPages;
    readingEvents.add(event);
  }

  int getReadingPages() {
    return lastPageRead;
  }

  Duration getReadingTime() {
    return readingTime;
  }

  double getReadingPercentage() {
    return readingPercentage;
  }

  Map<String, dynamic> toMap() {
    List<Map<String, dynamic>> readingEventsMap = [];
    for (int i = 0; i < readingEvents.length; i++) {
      readingEventsMap.add(readingEvents[i].toMap());
    }
    return {
      "id": id,
      "name": name,
      "totalPages": totalPages,
      "localImage": localImage,
      "imageUrl": imageUrl,
      "readingPercentage": readingPercentage,
      "readingPages": lastPageRead.toString(),
      "readingTime": readingTime.inMilliseconds,
      "readingEvents": readingEventsMap,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    List<ReadingEvent> readingEvents = [];
    return Book(
      id: map["id"],
      name: map["name"],
      totalPages: map["totalPages"],
      imageUrl: map["imageUrl"],
      localImage: map["localImage"],
      lastPageRead: int.parse(map["readingPages"]),
      readingPercentage: map["readingPercentage"],
      readingTime: Duration(milliseconds: map["readingTime"]),
      readingEvents: readingEvents,
    );
  }
}

class ReadingEvent {
  DateTime readingDate;
  Duration readingTime;
  int lastPageRead = 0;

  ReadingEvent({
    required this.readingDate,
    required this.readingTime,
    required this.lastPageRead,
  });

  Map<String, dynamic> toMap() {
    return {
      "readingDate": readingTime.toString(),
      "readingTime": readingTime.inMilliseconds,
      "readingPages": lastPageRead.toString(),
    };
  }

  static ReadingEvent fromMap(Map<String, dynamic> map) {
    return ReadingEvent(
      readingDate: DateTime.parse(map["readingDate"]),
      readingTime: Duration(milliseconds: int.parse(map["readingTime"])),
      lastPageRead: int.parse(map["readingPages"]),
    );
  }
}
