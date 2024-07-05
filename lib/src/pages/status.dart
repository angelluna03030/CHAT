import 'package:chat/src/services/socket_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

class StatusPage extends StatelessWidget {
  const StatusPage({super.key});
  
  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      body: const Center(
        child: Text(
          'Estado del servidor:',
          style: TextStyle(fontSize: 24),
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: 
      (){
        // {nombre: "Flutter", message: "hola flutter"}
        socketService.emit('emitir-mensaje',{'nombre': "Flutter", 'mensaje': "hola flutter"} );
      },
      child: const Icon(Icons.message),
      ),
    );
  }
}
