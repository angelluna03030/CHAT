import 'dart:io';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../models/band.dart';
import '../services/socket_services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    @override
    // ignore: unused_element
    void initState() {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket!.on(
          'active-bands',
          (p) => {
                // ignore: unnecessary_this
                this.bands =
                    (p as List).map((band) => Band.fromMap(band)).toList(),
                setState(() {})
              });
      super.initState();
    }

    @override
    // ignore: unused_element
    void dispose() {
      final socketService = Provider.of<SocketService>(context, listen: false);
      socketService.socket!.off('active-bands');
      super.dispose();
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Center(child: Text('Bandas Nombre')),
        actions: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 10),
            child: socketService.serverStatus == ServerStatus.Online
                ? Icon(Icons.check_circle, color: Colors.blue[300])
                : Icon(
                    Icons.offline_bolt,
                    color: Colors.red[300],
                  ),
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          _showGraph(),
Expanded(
  child: ListView.builder(
          itemCount: bands.length,
          itemBuilder: (context, i) => BandTile(bands[i]),
        ),
),
          
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNewBand(context);
        },
        elevation: 1,
        child: const Icon(Icons.add),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget BandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);

    return Dismissible(
      key: Key(band.id),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) => {
        socketService.emit("add-band", {'id': band.id})
      },
      background: Container(
          color: Colors.red,
          padding: const EdgeInsets.only(left: 8.0),
          child: const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.delete_rounded,
              color: Colors.white,
            ),
          )),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text('${band.votes}', style: const TextStyle(fontSize: 20)),
        onTap: () {
          socketService.socket!.emit('vote-band', {'id': band.id});
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
                    addBandToList(textController.text);
                  }
                },
                elevation: 5,
                child: const Text("Agregar"),
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

  void addBandToList(String name) {
    final socketServices = Provider.of<SocketService>(context, listen: false);
    socketServices.emit("add-band", {"name": name});
    Navigator.pop(context);
  }
  //mostrar Grafica
 Widget _showGraph() {
Map<String, double> dataMap = new Map();
bands.forEach((band){
  dataMap.putIfAbsent(band.name, () => band.votes.toDouble());
});

  return Container(
    width: double.infinity,
    height: 200,
    child: PieChart(dataMap: dataMap));
  



  }
}
