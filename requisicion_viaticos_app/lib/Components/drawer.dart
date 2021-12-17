import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DrawerComponent extends StatefulWidget {
  @override
  _DrawerComponentState createState() => _DrawerComponentState();
}

class _DrawerComponentState extends State<DrawerComponent> {

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
        title: Text('Listado de requisiciones'),
        onTap: () {                    
        },
        leading: Icon(Icons.assignment_rounded),
      ),
    ],
  ),
);
  }
  
}