
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/MainPage/index.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/CardRequisicion.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/Metodos.dart';

class VisualizarRequisiciones extends StatefulWidget {

  final Map<String,String> Diccionario;
  final String ID_USUARIO;

  const VisualizarRequisiciones(this.Diccionario,this.ID_USUARIO,{Key ? key}) : super(key: key);

  @override
  VisualizarRequisiciones_ createState() => VisualizarRequisiciones_();
}

class VisualizarRequisiciones_ extends State<VisualizarRequisiciones> {

  List<Historial> _HistorialRequisiciones_ = [];

  void initState() {    
    VisualizarRequisiciones_();
    super.initState();
  }

  VisualizarRequisiciones_()
  {
        getConstant("usuario").then((val) => setState(() {

          HistorialRequisiciones_().then((val2) => setState(() {                                      
            _HistorialRequisiciones_ = val2; 
          }));

        }));
  }

   Future<String> getConstant(String msg) async {    
    String DPI = '';    
    return DPI;
  }

Future<List<Historial>> HistorialRequisiciones_() async
  {
     showDialog(
        context: context,
        builder: (context) => Spinner(),
        barrierDismissible: false);
    List<Historial> lst = await HistorialRequisiciones().ObtenerHistorial(widget.ID_USUARIO,widget.Diccionario); 
    Navigator.of(context).pop(true);                 
    return lst;
  }
  
  
   @override  
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: new AppBar(
        title: Text("Historial de requisiciones"),
        centerTitle: true,
        leading: 
        Container(          
          child:
        IconButton(
          onPressed: () {
                 Navigator.pop(context);
          },
           icon: Icon(Icons.arrow_back),
          ))
      ),
      body: SingleChildScrollView(
        child: Container(alignment: Alignment.bottomCenter,child: Column(children: [  
        SizedBox(height: 10,)      ,
        for(var tmp in _HistorialRequisiciones_)
            PermisosRequestCard(tmp)
      ],),),
      )
    );    
  }  
  

}
