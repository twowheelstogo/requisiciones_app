
import 'package:flutter/material.dart';
import 'package:requisicion_viaticos_app/Components/Spinner.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/CardRecientes.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/CardRequisicion.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/Metodos.dart';

class VisualizarRequisicionesRecientes extends StatefulWidget {

  final Map<String,String> Diccionario;
  final String ID_USUARIO;

  const VisualizarRequisicionesRecientes(this.Diccionario,this.ID_USUARIO,{Key ? key}) : super(key: key);

  @override
  VisualizarRequisicionesRecientes_ createState() => VisualizarRequisicionesRecientes_();
}

class VisualizarRequisicionesRecientes_ extends State<VisualizarRequisicionesRecientes> {

  List<RequisicionesFormato> _HistorialRequisiciones_ = [];
  TextEditingController Estado = TextEditingController();
  TextEditingController Agencia = TextEditingController();
  
  void initState() {    
    VisualizarRequisiciones_();
    Estado.text = "";
    Agencia.text = "";
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

Future<List<RequisicionesFormato>> HistorialRequisiciones_() async
  {
     showDialog(
        context: context,
        builder: (context) => Spinner(),
        barrierDismissible: false);
    List<RequisicionesFormato> lst = await RequisicionesRecientes_().ObtenerRequisicionesActivas(widget.ID_USUARIO,widget.Diccionario); 
    Navigator.of(context).pop(true);                 
    return lst;
  }

  List<RequisicionesFormato> ListaFiltrada() {    
    String tmp2 = Agencia.text.toString();  
    List<RequisicionesFormato> newLst2 = _HistorialRequisiciones_
        .where((o) => o.Agencias.toLowerCase().contains(tmp2.toLowerCase()))
        .toList();    
    return newLst2;
  }

  
  
   @override  
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: new AppBar(
        title: Text("Requisiciones de los ultimos 30 días",style: TextStyle(fontSize: 15),),
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
        Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFieldDinamico__(
                            Agencia, 'Busqueda por Agencia')),
        for(var tmp in ListaFiltrada())
            PermisosRecientesRequestCard(tmp)
      ],),),
      )
    );    
  } 


  Widget TextFieldDinamico__(
      TextEditingController controlador, String Label) {
    return TextField(
      controller: controlador,
      decoration: InputDecoration(                    
                      labelText:Label,                     
                      labelStyle: TextStyle(fontSize: 17,color: Colors.black),                                    
                ),    
    );
  } 
  

}