import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:chat/global/environment.dart';
import 'package:chat/services/auth_service.dart';
import 'package:chat/models/mensajes_response.dart';
import 'package:chat/models/usuario.dart';

class ChatService with ChangeNotifier {
  Usuario usuarioPara;

  Future<List<Mensage>> getChat(String usuarioID) async {
    final resp = await http.get('${Environment.apUrl}/mensajes/$usuarioID',
        headers: {
          'Content-Type': 'application/json',
          'x-token': await AuthService.getToken()
        });

    final mensajesResp = mensajesResponseFromJson(resp.body);

    return mensajesResp.mensages;
  }
}
