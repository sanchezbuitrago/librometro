import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/buttons.dart';
import 'package:librometro/core/presentation/widgets/scaffold.dart';
import 'package:librometro/core/services/routes.dart';
import 'package:librometro/dashboard/domain/models/events.dart';
import 'package:librometro/dashboard/domain/models/books.dart';
import 'package:librometro/dashboard/domain/veiw_model/dashboard.dart';
import 'package:librometro/dashboard/presentation/widgets/book_card.dart';
import 'package:librometro/dashboard/presentation/widgets/statistic_card.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  DashboardViewModel viewModel = DashboardViewModel();
  List<StatisticCard> statistics = [];
  List<Book> inProcessBooks = [];

  @override
  void initState(){
    super.initState();
    getStatistics();
  }

  void getStatistics() async {
    LibraryEvent getStatisticsResponse = await viewModel.getStatistics();
    processLibraryEvents(getStatisticsResponse);
  }

  void processLibraryEvents(LibraryEvent event){
    if(event is LibraryStatisticsConsulted){
      setState(() {
        inProcessBooks = event.inProgressBooks;
        statistics.add(StatisticCard(name: "En proceso", value: event.inProgressBooks.length.toString()));
        statistics.add(StatisticCard(name: "Finalizados", value: event.finalizeBooks.length.toString()));
        statistics.add(StatisticCard(name: "Pendientes", value: event.pendingBooks.length.toString()));
        statistics.add(StatisticCard(name: "Horas de Lectura", value: event.readingHours.toString()));
        statistics.add(StatisticCard(name: "Paginas por minuto", value: event.pagesMerMinute.toString()));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget optionsGrid = Wrap(
      spacing: 10,
      runSpacing: 10,
      children: [
        ...statistics
      ],
    );

    Widget bookList = Column(
      children: [
        ...List.generate(inProcessBooks.length, (index) {
          return BookCard(book: inProcessBooks[index]);
        }),
      ],
    );

    return DefaultScaffold(
      appBarTitle: "Librómetro",
      bottomNavigationBar: DefaultButtonNavigationBar(child: Text("Agregar Libro"), onPressed: (){
        AppRoutes.navigateTo(context, AppRoutes.createBook);
      },),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Estadísticas",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            // 🟦 optionsGrid dentro de un SizedBox con altura fija
            Container(margin: EdgeInsets.all(10), child: optionsGrid),

            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                "Mis libros",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),

            // 🟩 bookList dentro de su propio Column
            bookList,
          ],
        ),
      ),
    );
  }
}
