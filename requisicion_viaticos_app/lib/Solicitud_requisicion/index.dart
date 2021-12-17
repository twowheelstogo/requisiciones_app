import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:requisicion_viaticos_app/Solicitud_requisicion/CreateRequisicionModal.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/index.dart';


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

    void VisualizarRequisiones_(context)
    {
      Navigator.push<void>(
      context,
      MaterialPageRoute<void>(
        builder: (BuildContext context) => VisualizarRequisiciones(),
      ),
    );
    }

     void openModal(){
    showModalBottomSheet(context: context,
           isScrollControlled: true,
        isDismissible: false,
        enableDrag: false,
          builder: (context) {
      return CalendarModal();
    });
  }
    

   @override  
  Widget build(BuildContext context) {
   final size = MediaQuery.of(context).size;
    return 
    Container(
    alignment: Alignment.center,
    child:     
    Column(children: [
        Requsion_('Generar nueva solicitud de requisición',0,size),
        Requsion_('Adjuntar detalles a una requisición',0,size),
        Requsion_('Visualizar historial de requisiciones',1,size)
    ],)
    );
  }  

  Widget Requsion_(String Mensajes, int opcion,final size)
  {
    return  Container(
                            alignment: Alignment.center,                            
                            child: 
                            ButtonTheme(
                                  minWidth: MediaQuery.of(context).size.width * 0.9,          
                        child:    OutlineButton(                                
                                 borderSide: BorderSide(
                                      width: 1,
                                      color: Color.fromRGBO(56, 56, 56, 1)),
                                  textColor: Color.fromRGBO(56, 56, 56, 1),                                
                                onPressed: ()  { 
                                    if(opcion == 0)
                                    {
                                        openModal();
                                    }else{

                                      VisualizarRequisiones_(context);
                                    }
                                 },
                                child: Text(
                                  Mensajes,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ))),
                          );
  }  

}