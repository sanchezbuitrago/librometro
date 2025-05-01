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
       totalReadingPages = totalReadingPages ?? 0;

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
  String name;
  int totalPages;
  String? localImage;
  String imageUrl;
  double readingPercentage;
  int readingPages;
  Duration readingTime;

  List<ReadingEvent> readingEvents;

  Book({
    required this.name,
    required this.totalPages,
    this.localImage,
    this.imageUrl =
        "https://upload.wikimedia.org/wikipedia/commons/a/a3/Image-not-found.png",
    this.readingPercentage = 0,
    this.readingPages = 0,
    this.readingTime = const Duration(),
    this.readingEvents = const [],
  });

  void addReadingEvent(ReadingEvent event) {
    readingPages = readingPages + event.readingPages;
    readingTime = readingTime + event.readingTime;
    readingPercentage = readingPages * 100 / totalPages;
    readingEvents.add(event);
  }

  int getReadingPages() {
    return readingPages;
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
      "name": name,
      "totalPages": totalPages,
      "localImage": localImage,
      "imageUrl": imageUrl,
      "readingPercentage": readingPercentage,
      "readingPages": readingPages.toString(),
      "readingTime": readingTime.inMilliseconds,
      "readingEvents": readingEventsMap,
    };
  }

  static Book fromMap(Map<String, dynamic> map) {
    List<ReadingEvent> readingEvents = [];
    return Book(
      name: map["name"],
      totalPages: map["totalPages"],
      imageUrl: map["imageUrl"],
      localImage: map["localImage"],
      readingPages: int.parse(map["readingPages"]),
      readingPercentage: map["readingPercentage"],
      readingTime: Duration(milliseconds: map["readingTime"]),
      readingEvents: readingEvents,
    );
  }
}

class ReadingEvent {
  DateTime readingDate;
  Duration readingTime;
  int readingPages = 0;

  ReadingEvent({
    required this.readingDate,
    required this.readingTime,
    required this.readingPages,
  });

  Map<String, dynamic> toMap() {
    return {
      "readingDate": readingTime.toString(),
      "readingTime": readingTime.inMilliseconds,
      "readingPages": readingPages.toString(),
    };
  }

  static ReadingEvent fromMap(Map<String, dynamic> map) {
    return ReadingEvent(
      readingDate: DateTime.parse(map["readingDate"]),
      readingTime: Duration(milliseconds: int.parse(map["readingTime"])),
      readingPages: int.parse(map["readingPages"]),
    );
  }
}
