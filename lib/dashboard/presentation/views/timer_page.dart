import 'dart:io';

import 'package:flutter/material.dart';
import 'package:librometro/core/presentation/widgets/buttons.dart';
import 'package:librometro/core/presentation/widgets/form_fields.dart';
import 'package:librometro/core/presentation/widgets/scaffold.dart';
import 'package:librometro/core/services/routes.dart';
import 'package:librometro/dashboard/domain/veiw_model/timer.dart';
import 'package:librometro/dashboard/presentation/widgets/timer.dart';

import 'package:librometro/dashboard/domain/models/books.dart';


class TimerPage extends StatefulWidget {
  final Book book;
  const TimerPage({super.key, required this.book});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool timerRunning = false;
  Duration readingTime = Duration();
  TimerViewModel timerViewModel = TimerViewModel();

  final _readingPagesFormKey = GlobalKey<FormState>();
  final _readingPagesController = TextEditingController();

  void onRunning(bool running){
    setState(() {
      timerRunning = running;
    });
  }

  void onPause(Duration duration){
    setState(() {
      readingTime = duration;
    });
  }

  void saveReadingTime() async {
    if(_readingPagesFormKey.currentState?.validate() ?? false){
      print("Click para guardar el tiempo transcurrido");
      await timerViewModel.addReadingTimeToBook(widget.book.id, readingTime, 10);
      if(mounted){
        AppRoutes.goBack(context)?.then((value){
          if(mounted){
            AppRoutes.goBack(context);
          }
        });
      }
    }
  }

  _showCreateInvestmentDialog(context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Form(
                key: _readingPagesFormKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DefaultTextFormField(
                      controller: _readingPagesController,
                      labelText: "Número de paginas leidas",
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Este campo es requerido";
                        }

                        if(int.tryParse(value) == null){
                          return "Se debe ingresar un número entero";
                        }
                        return null;
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.all(5),
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: ElevatedButton(
                          onPressed: (){saveReadingTime();},
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.secondary),
                          child: Text('Agregar número de paginas', style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultScaffold(
        appBarTitle: "Cronómetro de lectura",
        bottomNavigationBar: DefaultButtonNavigationBar(
            onPressed: timerRunning || readingTime.inMilliseconds == 0 ? null : (){
              _showCreateInvestmentDialog(context);
            },
            child: Text("Guardar Tiempo de Lectura")
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                Container(
                  width: 160,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Color.fromRGBO(0, 0, 0, 0.4),
                        spreadRadius: 5,
                        blurRadius: 5,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 160,
                      height: 200,
                      color: Colors.grey,
                      child:
                      widget.book.localImage == null
                          ? Center(
                        child: Icon(Icons.photo_album, color: Colors.black),
                      )
                          : Image.file(File(widget.book.localImage!), fit: BoxFit.cover),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                BookTimer(onRunning: onRunning, onPause: onPause,),
              ],
            ),
          ),
        )
    );
  }
}
