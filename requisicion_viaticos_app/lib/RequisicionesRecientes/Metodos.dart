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
  final String ID_Tarifario;
  final String DISPONIBLE_HOSPEDAJE;
  final String DISPONIBLE_GASOLINA;
  final String DISPONIBLE_COMIDA;
  final String LIQUIDADO;
  final String DEPRECIACION;

  RequisicionesFormato({
    required this.Inicio,
    required this.Fin,
    required this.Agencias,
    required this.Status,
    required this.Monto,
    required this.ID,
    required this.ID_Tarifario,
    required this.DISPONIBLE_HOSPEDAJE,
    required this.DISPONIBLE_GASOLINA,
    required this.DISPONIBLE_COMIDA,
    required this.LIQUIDADO,
    required this.DEPRECIACION
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
          Monto: tmp[i]["fields"]["MONTO_VIATICOS"].toString(),
          ID_Tarifario: tmp[i]["fields"]["TARIFARIO_VIATICOS"][0].toString(),
          DISPONIBLE_HOSPEDAJE: tmp[i]["fields"]["DISPONIBLE HOSPEDAJE"] == null ?
          '0' : tmp[i]["fields"]["DISPONIBLE HOSPEDAJE"][0].toString(),          
          DISPONIBLE_GASOLINA: tmp[i]["fields"]["DISPONIBLE GASOLINA"] == null ?
          '0' : tmp[i]["fields"]["DISPONIBLE GASOLINA"][0].toString(),
          DISPONIBLE_COMIDA: tmp[i]["fields"]["DISPONIBLE COMIDA"] == null ? '0'
          : tmp[i]["fields"]["DISPONIBLE COMIDA"][0].toString(),
          LIQUIDADO: tmp[i]["fields"]["LIQUIDADO"] == null ? '0'
          : tmp[i]["fields"]["LIQUIDADO"].toString(),
          DEPRECIACION: tmp[i]["fields"]["DEPRECIACION"] == null ? '0'
          : tmp[i]["fields"]["DEPRECIACION"].toString()
          ),                    
          );
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

  Future<http.Response> crearDetallesLiquidacion(String FECHA_FACTURA, String Tipo,double Monto,String url1,String url2,String ID,String ID2)async{
       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };

    var Arreglo1 = [{"url":url1},{"url":url2}];
    var Arreglo2 = [{"url":url1}];
    
    Map<String, dynamic> body = {
      "FECHA_FACTURA" : FECHA_FACTURA,
      "TIPO_GASTO" : Tipo.toUpperCase(),
      "MONTO" : Monto,
      "FOTO_FACTURA" : (url1.length > 0 && url2.length > 0) ? Arreglo1 : Arreglo2,
      "REQUISICION_VIATICOS" : [ID],  
      "TARIFARIO_VIATICOS" : [ID2]          
    };

    final bodyEncoded = json.encode({
      "records": [
        {"fields": body}
      ]
    });

    print(bodyEncoded);

     String url = urlApi + 'DETALLE_LIQUIDACION';    
    try {
      final response = await http.post(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }



}