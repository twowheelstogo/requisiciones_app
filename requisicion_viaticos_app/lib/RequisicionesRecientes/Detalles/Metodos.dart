import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/Config/constants.dart';
import 'dart:convert';

class RequisicionesDetallesFormato with ChangeNotifier {

  final String Fecha;
  final String TIPO_GASTO;
  final String MONTO;
  final List FOTO_FACTURA;  
  final String FECHA_FACTURA;
  final String ID;

  RequisicionesDetallesFormato({
    required this.Fecha,
    required this.TIPO_GASTO,
    required this.MONTO,
    required this.FOTO_FACTURA,    
    required this.FECHA_FACTURA,
    required this.ID
  });
}

class DetallesRequisicionesRecientes {

  Future <List<RequisicionesDetallesFormato> > ObtenerRequisicionesActivas(String id) async
  {
    List<RequisicionesDetallesFormato> Historial_ = [];    
    final Response = await getRequisiciones(id);

    if(Response.statusCode == 200)
    {
      final Decoded = json.decode(Response.body);
      if(Decoded.length > 0)
      {
        final tmp = Decoded["records"];
        
        for(int i = 0; i < tmp.length;i++)
        {                    
          Historial_.add(
            RequisicionesDetallesFormato(Fecha: tmp[i]["fields"]["FECHA_INGRESADO"].toString(), 
            TIPO_GASTO: tmp[i]["fields"]["TIPO_GASTO"].toString(), 
            MONTO: tmp[i]["fields"]["MONTO"].toString(), 
            FOTO_FACTURA: tmp[i]["fields"]["FOTO_FACTURA"],
            FECHA_FACTURA: tmp[i]["fields"]["FECHA_FACTURA"],
            ID: tmp[i]["fields"]["TARIFARIO_VIATICOS"][0]
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
        "DETALLE_LIQUIDACION" + "?filterByFormula=AND(({DOCUMENTO_COLABORADOR}= '" + NombreUsuario + "'),(DATETIME_DIFF(TODAY(),{FECHA_INGRESADO}, '" + Tipo + "') <= 31))&sort%5B0%5D%5Bfield%5D=FECHA_INGRESADO&sort%5B0%5D%5Bdirection%5D=desc";
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }
}