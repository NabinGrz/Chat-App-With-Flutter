import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart';


class SocketUseCase {
  Socket? chatSocket;

  SocketUseCase() {
    _handleAllConnections();
  }

  bool get isSocketConnected => chatSocket?.connected ?? false;

  void listenToEvent({
    required String eventName,
    required Function(dynamic) handler,
  }) {
    chatSocket?.on(eventName, handler);
  }

  void emit({
    required String eventName,
    required data,
  }) {
    chatSocket?.emit(eventName, data);
  }

  Future<void> startSocketConnection() async {
    final sharedPreference = await SharedPreferences.getInstance();
    String? token = sharedPreference.getString('accessToken');

    chatSocket = io(
      "http://192.168.1.85:8080",
      OptionBuilder().setTransports(['websocket', 'polling']).setExtraHeaders(
          {"extra": "mobile-1"}).setAuth({"token": token}).build(),
    );

    chatSocket?.connect();
  }

  void _handleAllConnections() async {
    await startSocketConnection();

    listenToEvent(
      eventName: 'connection',
      handler: (_) => _handleConnectionSuccess(),
    );

    listenToEvent(
      eventName: 'connected',
      handler: (_) => _handleConnectedSuccess(),
    );

    chatSocket?.onDisconnect((_) {
      _handleConnectionDisconnect();
    });

    chatSocket?.onConnectError((err) {
      _handleConnectionError(err.toString());
    });

    chatSocket?.onError((err) {
      _handleConnectionError(err.toString());
    });
  }

  void _handleConnectionSuccess() {
    if (isSocketConnected) {
      debugPrint('ChatSocket[Connected]: Successfully Connected to server!!');
    } else {
      debugPrint('ChatSocket: Socket is not connected!!');
    }
  }

  void _handleConnectedSuccess() {
    debugPrint('ChatSocket: Successfully Connected to server!!');
  }

  void _handleConnectionDisconnect() {
    debugPrint('ChatSocket[Disconnected]: Connection Disconnected');
  }

  void _handleConnectionError(String errorMessage) {
    // debugPrint("ChatSocket[Error]: $errorMessage");
  }

  void dispose() {
    chatSocket?.disconnect();
    chatSocket?.destroy();
    chatSocket?.dispose();
  }
}
