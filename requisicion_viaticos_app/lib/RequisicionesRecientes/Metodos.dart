// ignore: file_names
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Config/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class RequisicionesFormato with ChangeNotifier {

  final String Inicio;
  final String Fin;
  final String Agencias;
  final String Status;
  final String Monto;
  final String ID;

  RequisicionesFormato({
    required this.Inicio,
    required this.Fin,
    required this.Agencias,
    required this.Status,
    required this.Monto,
    required this.ID
  });

}

// ignore: camel_case_types
class RequisicionesRecientes_ 
{
  Future <List<RequisicionesFormato> > ObtenerRequisicionesActivas(String id,Map<String,String> Diccionario) async
  {
    List<RequisicionesFormato> Historial_ = [];
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
          Historial_.add(RequisicionesFormato(
          Inicio: tmp[i]["fields"]["FECHA_INICIO_VIAJE"].toString(), 
          Fin: tmp[i]["fields"]["FECHA_RETORNO_VIAJE"].toString(), 
          Agencias: nombre_.toString(), 
          Status: tmp[i]["fields"]["STATUS"].toString(), 
          ID: tmp[i]["fields"]["ID"].toString(),
          Monto: tmp[i]["fields"]["MONTO_VIATICOS"].toString()));
        }
      }
    }

    return Historial_;
  }

   Future<http.Response> getRequisiciones(String NombreUsuario) async {     
     String Tipo = 'days';
     String Status = 'APROBADA';
    String url = urlApi +
        "REQUISICION_VIATICOS" + "?filterByFormula=AND(({No_Documento}= '" + NombreUsuario + "'),(DATETIME_DIFF(TODAY(),{FECHA_RETORNO_VIAJE}, '" + Tipo + "') <= 31),({STATUS}='" + Status + "'))&sort%5B0%5D%5Bfield%5D=FECHA_RETORNO_VIAJE&sort%5B0%5D%5Bdirection%5D=desc";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };

    print(url);
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }


}