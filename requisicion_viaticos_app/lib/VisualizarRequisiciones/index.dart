
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

  List<Historial> ListaFiltrada() {
    String tmp1 = Estado.text.toString();
    String tmp2 = Agencia.text.toString();
    List<Historial> newLst = _HistorialRequisiciones_
        .where((o) => o.Status.toLowerCase().contains(tmp1.toLowerCase()))
        .toList();
    List<Historial> newLst2 = newLst
        .where((o) => o.Agencias.toLowerCase().contains(tmp2.toLowerCase()))
        .toList();    
    return newLst2;
  }

  
  
   @override  
  Widget build(BuildContext context) {
    return 
    Scaffold(
      appBar: new AppBar(
        title: Text("Historial de requisiciones",style: TextStyle(fontSize: 17),),
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
                            Estado, 'Busqueda por Status')),
        Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width * 0.9,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFieldDinamico__(
                            Agencia, 'Busqueda por Región')),
        ListaFiltrada().length > 0 ?           
        Column(children: [for(var tmp in ListaFiltrada())
            PermisosRequestCard(tmp)],)
        : Container(alignment:Alignment.topCenter ,child: Column(children: [SizedBox(height: MediaQuery.of(context).size.width * 0.5,) ,Text('Sin requisiciones.',style:TextStyle(fontSize: 17))],))
                            
        
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
