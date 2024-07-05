import 'dart:io';

import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  Online,
  Offline,
  Connecting
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;
  IO.Socket? get socket => this._socket;
  Function get emit => this._socket!.emit;
  SocketService() {
    _initConfig();
  }
void _initConfig() {
  try {
    _socket = IO.io('http://192.168.1.15:3000', <String, dynamic>{
      'transports': ['websocket'], // Puedes intentar con ['polling', 'websocket'] si solo websocket falla
      'autoConnect': true,
      'timeout': 15000, // Tiempo de espera en milisegundos (5 segundos)
    });

    _socket?.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
      print('Conectado al servidor');
    });

    _socket?.on('connect_error', (error) {
      print('Error de conexión: $error');
    });

    _socket?.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
      print('Desconectado del servidor');
    });

    _socket?.on('nuevo-mensaje', (p) {
      print('Nuevo mensaje: ${p.toString()}');
    });
  } catch (e) {
    print('Error de conexión: $e');
  }
}

  void sendMessage(String message) {
    if (_socket != null && _socket!.connected) {
      _socket!.emit('mensaje', {'nombre': message});
    } else {
      print('No se pudo enviar el mensaje. No conectado al servidor.');
    }
  }


}
