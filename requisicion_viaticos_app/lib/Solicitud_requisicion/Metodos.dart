import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:requisicion_viaticos_app/config/constants.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ListadoAgencias{

  void Storage(Map<String,String> diccionario) async
  {
    final prefs = await SharedPreferences.getInstance();
    var s = json.encode(diccionario);
    prefs.setString('Diccionario', s.toString());
  }

  void Costos(Map<String, String> DiccionarioCostos) async
  {
    final prefs = await SharedPreferences.getInstance();    
    prefs.setString('DESAYUNO', DiccionarioCostos["DESAYUNO"].toString());
    prefs.setString('ALMUERZO', DiccionarioCostos["ALMUERZO"].toString());
    prefs.setString('CENA', DiccionarioCostos["CENA"].toString());
    prefs.setString('GASOLINA', DiccionarioCostos["GASOLINA"].toString());
    prefs.setString('HOSPEDAJE', DiccionarioCostos["HOSPEDAJE"].toString());
  }

  Future<String> ObtenerCostos(String llave) async
  {
    final prefs = await SharedPreferences.getInstance(); 
    return prefs.getString(llave).toString();
  }
  


  Future<http.Response> crearTarifario()async{
       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    String now = DateFormat("yyyy-MM-dd").format(DateTime.now());

    Map<String, dynamic> body = {
      "FECHA_CREACION" : now.toString()      
    };

    final bodyEncoded = json.encode({
      "records": [
        {"fields": body}
      ]
    });

     String url = urlApi + 'TARIFARIO_VIATICOS';
    print(bodyEncoded);
    try {
      final response = await http.post(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }
  

  Future<bool> RegistrosActividades(List fechas,String TipoCombustible,String ID,String ID_Agencia,double Kilometros) async
  {    
    int contador = 0;
    for(int i =0;i < fechas.length; i++){
      DateTime nuevo = DateTime.parse(fechas[i]);
      String tmp = DateFormat("yyyy-MM-dd").format(nuevo).toString();
      final Response = await crearDetallesActividades(ID,TipoCombustible,tmp,ID_Agencia,Kilometros);
      if(Response.statusCode == 200) {contador++;}
    }
    if(contador == fechas.length){return true;}
    else{return false;}
  }

  Future<http.Response> crearDetallesActividades(String ID,String TipoCombustible,String fecha,String ID_Agencia,double Kilometros) async
  {        
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    
    Map<String, dynamic> body = {
      "REQUISICION_VIATICOS"   : [ID.replaceAll(" ","")],
      "TIPO_COMBUSTIBLE" : TipoCombustible,
      "FECHA" : fecha,
      "BANRURAL_CATALOGOS_AGENCIA": [ID_Agencia.replaceAll(" ", "")] ,
      "KILOMETROS ESTIMADOS" : Kilometros
    };

    final bodyEncoded = json.encode({
      "records": [
        {"fields": body}
      ]
    });

    String url = urlApi + 'DETALLES_ACTIVIDADES';
    print(bodyEncoded);
    try {
      final response = await http.post(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }
    
   Future<http.Response> crearRequisicion(String Inicio, String Fin,double Monto,String ID_AGENCIA,String ID_USUARIO,String ID2,
   String Desayuno,String Almuerzo,String Cena,String Gasolina,String Hospedaje,
   bool bandera_comida,bool bandera_gasolina,bool bandera_hospedaje,String Kilometros,int totalDias
   ) async{
   
        
     double MontoHotel =  double.parse(Hospedaje) * double.parse(totalDias.toString());
     double MontoComida = ( double.parse(Desayuno) + double.parse(Almuerzo) + double.parse(Cena)) * double.parse(totalDias.toString());
     double MontoGasolina = ((double.parse(Kilometros) / 37) * double.parse(Gasolina));

     MontoHotel = bandera_hospedaje ? MontoHotel : 0;
     MontoComida = bandera_comida ? MontoComida : 0;
     MontoGasolina = bandera_gasolina ? MontoGasolina : 0;
       
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    
    Map<String, dynamic> body = {
      "FECHA_INICIO_VIAJE" : Inicio,
      "FECHA_RETORNO_VIAJE" : Fin,
      "MONTO_VIATICOS" : (MontoHotel+MontoComida+MontoGasolina),
      "AGENCIA" : [ID_AGENCIA],
      "STATUS" : "PENDIENTE",      
      "COLABORADORES": [ID_USUARIO],
      "TARIFARIO_VIATICOS" : [ID2],
      "MONTO_HOTEL" : MontoHotel,
      "MONTO_COMIDA" : MontoComida,
      "MONTO_GASOLINA" : MontoGasolina,      
    };

    final bodyEncoded = json.encode({
      "records": [
        {"fields": body}
      ]
    });

     String url = urlApi + 'REQUISICION_VIATICOS';
    print(bodyEncoded);
    try {
      final response = await http.post(Uri.parse(url),headers: headers,body: (bodyEncoded));
      return response;
    }on http.ClientException catch (e) {
      throw(e.message);
    }
  }




  Future<List> Agencias() async
  {    
    List<String> Agencias = [];
    Map<String,String> Diccionario = {};
    Map<String,String> DiccionarioCostos = {};

    bool Bandera = false;
    String paginacion = "";    
    do
    {    
    final Response = await ObtenerAgencias(paginacion);
    if(Response.statusCode == 200)
    {
      final Decoded = json.decode(Response.body);

      for(var i = 0; i < Decoded["records"].length; i++)
      {        
        final ID_AIRTABLE = Decoded["records"][i]["fields"]["ID"];
        final NOMBRE = Decoded["records"][i]["fields"]["TMP_REGION"];        

        if(!Diccionario.containsKey(NOMBRE.toString()))
        {
          Diccionario[NOMBRE.toString()] = ID_AIRTABLE.toString();
          Agencias.add(NOMBRE.toString());                                     
        }                                   

        if(!DiccionarioCostos.containsKey("DESAYUNO")){
          DiccionarioCostos["DESAYUNO"] = Decoded["records"][i]["fields"]["COSTO_DESAYUNO"][0].toString();
          DiccionarioCostos["ALMUERZO"] = Decoded["records"][i]["fields"]["COSTO_ALMUERZOS"][0].toString();
          DiccionarioCostos["CENA"] = Decoded["records"][i]["fields"]["COSTO_CENA"][0].toString();          
          DiccionarioCostos["GASOLINA SUPER"] = Decoded["records"][i]["fields"]["COSTO_GASOLINA_SUPER"][0].toString();
          DiccionarioCostos["GASOLINA REGULAR"] = Decoded["records"][i]["fields"]["COSTO_GASOLINA_REGULAR"][0].toString();
          DiccionarioCostos["GASOLINA DIESEL"] = Decoded["records"][i]["fields"]["COSTO_GASOLINA_DIESEL"][0].toString();
          DiccionarioCostos["HOSPEDAJE"] = Decoded["records"][i]["fields"]["COSTO_HOSPEDAJE"][0].toString();
        }
      }

      if(Decoded["offset"] != null)
      {
        paginacion = '?offset=${Decoded["offset"]}';
      }
      else{
        Bandera = true;
      }
    }
    }
    while(Bandera != true);
   
    Costos(DiccionarioCostos); 
    return [Agencias,Diccionario,DiccionarioCostos];    
  }

  Future<http.Response> ObtenerAgencias(String Paginacion) async {

     String url = urlApi +
        "BANRURAL_CATALOGOS_AGENCIA" + Paginacion;
      
    Map<String, String> headers = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': "Bearer $Token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: headers);
    return response;
  }

}
