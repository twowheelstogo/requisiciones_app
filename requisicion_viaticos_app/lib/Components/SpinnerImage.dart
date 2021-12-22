import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Spinner2 extends StatefulWidget {
  
  UploadTask? task;

  Spinner2(this.task,{Key ? key}) : super(key: key);
  @override
  Spinner_2 createState() => Spinner_2();
}

class Spinner_2 extends  State<Spinner2> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor:new AlwaysStoppedAnimation<Color>(Color.fromRGBO(255, 255, 255, 1)),
              ),
              SizedBox(height:20),
              //Text(widget.msg,style: TextStyle(  fontSize: 20,color: HexColor("#FFFFFF"),))
              widget.task != null ? buildUploadStatus(widget.task!) : Container(),
              //Theme.of(context).textTheme.headline3,)
            ],
          ),
        ),
      ),
    );
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
            );
          } else {
            return Container();
          }
        },
      );
      
}