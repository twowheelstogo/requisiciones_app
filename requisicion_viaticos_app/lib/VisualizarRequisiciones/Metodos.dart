// ignore: file_names
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class Historial with ChangeNotifier {

  final String Inicio;
  final String Fin;
  final String Agencias;
  final String Status;
  final String Monto;

  Historial({
    required this.Inicio,
    required this.Fin,
    required this.Agencias,
    required this.Status,
    required this.Monto
  });

}

// ignore: camel_case_types
class HistorialRequisiciones 
{
  Future <List<Historial> > ObtenerHistorial(String id,Map<String,String> Diccionario) async
  {
    List<Historial> Historial_ = [];
    final Response = await getRequisiciones(id);
    if(Response.statusCode == 200)
    {
      final Decoded = json.decode(Response.body);
      if(Decoded.length > 0)
      {
        final tmp = Decoded["records"];
        
        for(int i = 0; i < tmp.length;i++)
        {
          String agencia = tmp[i]["fields"]["AGENCIA"][0];
          var nombre_ = Diccionario.entries.firstWhere((entry) => entry.value
          == agencia).key;
          Historial_.add(Historial(
          Inicio: tmp[i]["fields"]["FECHA_INICIO_VIAJE"].toString(), 
          Fin: tmp[i]["fields"]["FECHA_RETORNO_VIAJE"].toString(), 
          Agencias: nombre_.toString(), 
          Status: tmp[i]["fields"]["STATUS"].toString(), 
          Monto: tmp[i]["fields"]["MONTO_VIATICOS"].toString()));
        }
      }
    }

    return Historial_;
  }

   Future<http.Response> getRequisiciones(String NombreUsuario) async {
    String url = urlApi +
        "REQUISICION_VIATICOS?filterByFormula=AND({No_Documento}='" +
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