import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:chat/global/environment.dart';
import 'package:chat/models/login_response.dart';
import 'package:chat/models/usuario.dart';

class AuthService with ChangeNotifier {
  Usuario usuario;
  bool _autenticando = false;

  // Create storage
  final _storage = new FlutterSecureStorage();

  bool get autenticando => this._autenticando;
  set autenticando(bool valor) {
    this._autenticando = valor;
    notifyListeners();
  }

  //Getters del token de forma estática
  static Future<String> getToken() async {
    final _storage = new FlutterSecureStorage();
    final token = await _storage.read(key: 'token');
    return token;
  }

  static Future<void> deleteToken() async {
    final _storage = new FlutterSecureStorage();
    await _storage.delete(key: 'token');
  }

  Future<bool> login(String email, String password) async {
    this.autenticando = true;

    final data = {'email': email, 'password': password};
    final resp = await http.post('${Environment.apUrl}/login',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    print(resp.body);
    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      //Guardar token en lugar seguro
      _guardarToken(loginResponse.token);
      return true;
    } else {
      return false;
    }
  }

  Future register(String nombre, String email, String password) async {
    this.autenticando = true;
    final data = {'nombre': nombre, 'email': email, 'password': password};
    final resp = await http.post('${Environment.apUrl}/login/new',
        body: jsonEncode(data), headers: {'Content-Type': 'application/json'});
    this.autenticando = false;
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      //Guardar token en lugar seguro
      _guardarToken(loginResponse.token);
      return true;
    } else {
      final respBody = jsonDecode(resp.body);
      return respBody['msg'];
    }
  }

  Future<bool> isLoggedInI() async {
    print('verificando 3');
    final token = await this._storage.read(key: 'token');
    print('verificando 4');
    final resp = await http.get('${Environment.apUrl}/login/renew',
        headers: {'Content-Type': 'application/json', 'x-token': token});
    print('verificando 5');
    if (resp.statusCode == 200) {
      final loginResponse = loginResponseFromJson(resp.body);
      this.usuario = loginResponse.usuario;
      //Guardar token en lugar seguro
      _guardarToken(loginResponse.token);
      return true;
    } else {
      this.logout();
      return false;
    }
  }

  Future _guardarToken(String token) async {
    // Write value
    return await _storage.write(key: 'token', value: token);
  }

  Future logout() async {
    // Delete value
    await _storage.delete(key: 'token');
  }
}
