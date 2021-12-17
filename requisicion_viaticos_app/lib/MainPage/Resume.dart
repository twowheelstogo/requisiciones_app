import 'package:flutter/material.dart';

class Resume extends StatelessWidget {
  
  int Pendientes;
  int rechazados;
  int Aprobados;

  Resume(this.Pendientes,this.rechazados,this.Aprobados,{Key ? key}):super(key:key);

  @override
  Widget build(BuildContext context) {    
    return Container(
      height:MediaQuery.of(context).size.width * 0.3,
      decoration: new BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        boxShadow: [
              BoxShadow(
                color: const Color(0x29000000),
                offset: Offset(0, 3),
                blurRadius: 6,
              ),
            ],
        color: Colors.black
      ),
      child: Padding(padding: EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment: Alignment.center,
            child:  Text("Resumen de requisiciones de víaticos",style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 15
          ),),
          ),
          Divider(thickness: 1,color: Colors.white,),
          Expanded(
              child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,    
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [    
                  Container(
                    alignment: Alignment.topRight,
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: timerResume("Pendientes", this.Pendientes.toString()),
                  ),                                
                  VerticalDivider(thickness: 2,color: Colors.white,),
                                    Container(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child:
                  timerResume("Aprobadas", this.Aprobados.toString())),
                  VerticalDivider(thickness: 2,color: Colors.white,),
                                    Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 0.20,
                    child:
                  timerResume("Rechazadas", this.rechazados.toString())),
                ],
              ),
            ),
          )
        ],
      ),),
    );
  }
  Widget timerResume(String title,String time){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(title,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w400,
          fontSize: 12        
        )),
        Text(time,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12
        ),
        ),
      ],
    );
  }
}