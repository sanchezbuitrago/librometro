import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/buttons.dart';
import 'package:librometro/core/presentation/widgets/scaffold.dart';
import 'package:librometro/core/services/routes.dart';
import 'package:librometro/dashboard/domain/models/events.dart';
import 'package:librometro/dashboard/domain/models/books.dart';
import 'package:librometro/dashboard/domain/veiw_model/dashboard.dart';
import 'package:librometro/dashboard/presentation/widgets/book_card.dart';
import 'package:librometro/dashboard/presentation/widgets/statistic_card.dart';

enum BookStatus{
  pending,
  finalized,
  inProcess
}

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  DashboardViewModel viewModel = DashboardViewModel();
  List<StatisticCard> statistics = [];
  List<Book> inProcessBooks = [];
  List<Book> pendingBooks = [];
  List<Book> finalizedBooks = [];
  BookStatus bookListType = BookStatus.inProcess;

  @override
  void initState() {
    super.initState();
    getStatistics();
  }

  void getStatistics() async {
    LibraryEvent getStatisticsResponse = await viewModel.getStatistics();
    processLibraryEvents(getStatisticsResponse);
  }

  void processLibraryEvents(LibraryEvent event) {
    if (event is LibraryStatisticsConsulted) {
      setState(() {
        inProcessBooks = event.inProgressBooks;
        pendingBooks = event.pendingBooks;
        finalizedBooks = event.finalizeBooks;
        statistics.clear();
        statistics.add(
          StatisticCard(
            name: "En proceso",
            value: event.inProgressBooks.length.toString(),
          ),
        );
        statistics.add(
          StatisticCard(
            name: "Finalizados",
            value: event.finalizeBooks.length.toString(),
          ),
        );
        statistics.add(
          StatisticCard(
            name: "Pendientes",
            value: event.pendingBooks.length.toString(),
          ),
        );
        statistics.add(
          StatisticCard(
            name: "Horas de Lectura",
            value: event.readingHours.toStringAsFixed(1),
          ),
        );
        statistics.add(
          StatisticCard(
            name: "Estimado de paginas por minuto",
            value: event.pagesMerMinute.toStringAsFixed(1),
          ),
        );
      });
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  Column getBookList(){
    List<Book> books = pendingBooks.reversed.toList();
    if(bookListType == BookStatus.finalized){
      books = finalizedBooks;
    }

    if(bookListType == BookStatus.inProcess){
      books = inProcessBooks;
    }

    return Column(
      children: [
        ...List.generate(books.length, (index) {
          return BookCard(book: books[index], goToTimer: (){
            AppRoutes.navigateTo(context, AppRoutes.bookTimer, arguments: books[index])?.then((value){
              getStatistics();
            });
          },);
        }),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget optionsGrid = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [...statistics],
    );

    List<DropdownMenuItem<BookStatus>> dropDownItems = [
      DropdownMenuItem<BookStatus>(
        value: BookStatus.inProcess,
        child: Text(capitalize(BookStatus.inProcess.name.trim())),
      ),
      DropdownMenuItem<BookStatus>(
        value: BookStatus.pending,
        child: Text(capitalize(BookStatus.pending.name.trim())),
      ),
      DropdownMenuItem<BookStatus>(
        value: BookStatus.finalized,
        child: Text(capitalize(BookStatus.finalized.name)),
      ),
    ];


    return DefaultScaffold(
      appBarTitle: "Librómetro",
      bottomNavigationBar: DefaultButtonNavigationBar(
        child: Text("Agregar Libro"),
        onPressed: () {
          AppRoutes.navigateTo(context, AppRoutes.createBook)?.then((value) {
            getStatistics();
          });
        },
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Estadísticas",
                style: Theme
                    .of(context)
                    .textTheme
                    .titleLarge,
              ),
            ),

            // 🟦 optionsGrid dentro de un SizedBox con altura fija
            Container(margin: EdgeInsets.all(10), child: optionsGrid),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      "Mis libros",
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: DropdownButton<BookStatus>(
                      value: bookListType,
                      iconEnabledColor: Colors.white,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleLarge,
                      items:dropDownItems,
                      onChanged: (value) {
                        if(value != null){
                          setState(() {
                            bookListType = value;
                          });
                        }
                      },
                    ),
                )
              ],
            ),
            getBookList(),
          ],
        ),
      ),
    );
  }
}
