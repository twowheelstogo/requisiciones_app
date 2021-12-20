// ignore: file_names
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

// ignore: camel_case_types
class Autenticacion 
{
  void storage_(usuario, id, ID_AIRTABLE,urlFoto,Genero) async {
    // obtain shared preferences
    final prefs = await SharedPreferences.getInstance();
    // set value
    prefs.setString('usuario', usuario);
    prefs.setString('DPI', id);
    prefs.setString('IdAIRTABLE', ID_AIRTABLE);
    prefs.setString('urlFoto', urlFoto);
    prefs.setString('Genero', Genero);    
  }


   // ignore: non_constant_identifier_names
  Future<List> Autenticar(String NombreUsuario) async {
    bool bandera = false;
    String Mensaje = "";
    //si es correcto entonces pasa a la siguiente vista
    final Response = await getAuthUserInfo(NombreUsuario);
    final Decoded = json.decode(Response.body);

    if (Response.statusCode == 200) {
      if (Decoded["records"].length > 0) {        
        var id = Decoded["records"][0]["fields"]["No_DOCUMENTO"];
        var Nombre = Decoded["records"][0]["fields"]["NOMBRE"];
        var ID_AIRTABLE = Decoded["records"][0]["id"];
        var Genero = Decoded["records"][0]["GENERO"];
        var Foto = Decoded["records"][0]["fields"]["FOTO_PERFIL"][0]["url"];
        storage_(Nombre.toString(), id.toString(), ID_AIRTABLE.toString(),Foto.toString(),Genero.toString());

      } else {
        bandera = true;
        Mensaje = "Credenciales incorrectas.";
      }
    } else {
      bandera = true;
      Mensaje = "Ha ocurrido un error, intente nuevamente.";
    }
    return [bandera, Mensaje];
  }


   Future<http.Response> getAuthUserInfo(String NombreUsuario) async {
    String url = urlApi +
        "COLABORADORES?filterByFormula=AND({No_DOCUMENTO}='" +
        NombreUsuario +
        "')";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }


}