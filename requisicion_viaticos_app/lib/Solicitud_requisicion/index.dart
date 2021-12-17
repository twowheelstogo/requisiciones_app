import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';


class Solicitud extends StatefulWidget {

  const Solicitud({Key? key}) : super(key: key);
  Solicitud_ createState() => Solicitud_();
}

class Solicitud_ extends State<Solicitud> {

    bool Bandera = false;
    TextEditingController FechaInicio = TextEditingController();
    TextEditingController FechaFin = TextEditingController();
    TextEditingController Monto = TextEditingController();
    String Agencia = "";

    Future<void> GenerarNuevaRequisicion () async {

    }

   @override  
  Widget build(BuildContext context) {
    return 
    Container(
    alignment: Alignment.center,
    child:     
    Column(children: [
        Crear_Requisicion('Generar nueva requisicion',GenerarNuevaRequisicion),
        Crear_Requisicion('Visualizar requisiciones pendientes',GenerarNuevaRequisicion)
    ],)
    );
  }  

  Widget Crear_Requisicion(String Mensajes, void Metodo)
  {
    return  Container(
                            alignment: Alignment.center,
                            child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  primary: Colors.black,
                                  backgroundColor: Colors.blueGrey,
                                  padding: EdgeInsets.all(10),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10))),
                                  minimumSize: Size(double.infinity, 40),
                                ),
                                onPressed: ()  {  Metodo;},
                                child: Text(
                                  Mensajes,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: HexColor("#FFFFFF"),
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                          );
  }
  


}