import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:requisicion_viaticos_app/VisualizarRequisiciones/index.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:requisicion_viaticos_app/RequisicionesRecientes/index.dart';

class DrawerComponent extends StatefulWidget {  
  final Map<String,String> Diccionario;

  DrawerComponent(this.Diccionario,{Key ? key}) : super(key: key);
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {
  
  String DPI = "";

 void initState() {    
    _DrawerComponentState();
    super.initState();
  }
  
  Future<String> getConstant(String msg) async {
    final prefs = await SharedPreferences.getInstance();
    String DPI = '';
    final res = prefs.getString(msg);
    DPI = '$res';
    return DPI;
  }

  _DrawerComponentState()
  {
     getConstant("DPI").then((val) => setState(() {
          DPI = val;        
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
  // Agrega un ListView al drawer. Esto asegura que el usuario pueda desplazarse
  // a través de las opciones en el Drawer si no hay suficiente espacio vertical
  // para adaptarse a todo.
  child: ListView(
    // Importante: elimine cualquier padding del ListView.
    padding: EdgeInsets.zero,
    children: <Widget>[
       DrawerHeader(
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10,),
                  Text("MRB Outsourcing",style: TextStyle(fontSize: 25,color: Colors.grey)),
                  Text(DateFormat("yyyy-MM-dd").format(DateTime.now()) ,style: TextStyle(fontSize: 15,color: Colors.grey)),                  
                ],
              ),
            ),
          ),
      ListTile(
            title: Text('Menú principal'),
            leading: Icon(Icons.home),
            onTap: () => Navigator.pop(context),
          ),
      ListTile(
        title: Text('Historial de requisiciones'),
        onTap: () {
          Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => VisualizarRequisiciones(widget.Diccionario,DPI),
        ),
      );                    
        },
        leading: Icon(Icons.assignment_rounded),
      ),
      ListTile(
        title: Text('Requisiciones del ultimó mes'),
        onTap: () {
          Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) => VisualizarRequisicionesRecientes(widget.Diccionario,DPI),
        ),
      );                    
        },
        leading: Icon(Icons.assignment_rounded),
      ),
    ],
  ),
);
  }
  
}