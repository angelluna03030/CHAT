import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../models/band.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: "1", name: "Metallica", votes: 5),
    Band(id: "2", name: "Queen", votes: 3),
    Band(id: "3", name: "The Beatles", votes: 4),
    Band(id: "4", name: "Mägo de Oz", votes: 5),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('Bandas Nombre')),
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => BandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewBand(context);
        },
        child: const Icon(Icons.add),
        elevation: 1,
      ),
    );
  }

 // ignore: non_constant_identifier_names
 Widget BandTile(Band band) {
    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: ( direction)=> print("direccion ${direction} y id ${band.id}") ,
      background: Container(color: Colors.red,
      padding: const EdgeInsets.only(left: 8.0),
        
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Icon(Icons.delete_rounded, color: Colors.white,),
        )
        ),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(band.name.substring(0, 2)),
          backgroundColor: Colors.blue[100],
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          print("Presionó ${band.name}");
        },
      ),
    );
  }

  void addNewBand(BuildContext context) {
    final TextEditingController textController = TextEditingController();
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Nueva Banda"),
            content: TextField(
              controller: textController,
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () {
                  if (textController.text.isNotEmpty) {
                    setState(() {
                      bands.add(Band(
                          id: DateTime.now().toString(),
                          name: textController.text,
                          votes: 5));
                    });
                    Navigator.pop(context);
                  }
                },
                child: const Text("Agregar"),
                elevation: 5,
              ),
            ],
          );
        },
      );
    } else {
      showCupertinoDialog(
          context: context,
          builder: (_) {
            return CupertinoAlertDialog(
              title: const Text("new ADDteam"),
              content: CupertinoTextField(
                controller: textController,
              ),
              actions: <Widget>[
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text("Agregar"),
                  onPressed: () {
                    if (textController.text.isNotEmpty) {
                      setState(() {
                        bands.add(Band(
                            id: DateTime.now().toString(),
                            name: textController.text,
                            votes: 5));
                      });
                      Navigator.pop(context);
                    }
                  },
                ),
                CupertinoDialogAction(
                  isDestructiveAction: true,
                  child: const Text("Salir"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            );
          });
    }
  }
}
