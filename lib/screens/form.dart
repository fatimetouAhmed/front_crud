import 'dart:convert';

import 'package:crud/screens/list.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';
import 'package:http/http.dart' as http;

import 'package:crud/screens/home.dart';
import 'dart:convert';
class MyForm extends StatefulWidget{
  final User user;
  MyForm({Key? key,required this.user}):super(key: key);
  @override
  _MyFormState createState()=> _MyFormState();


}
Future save(user) async{
  if(user.id ==0){
    await http.post(Uri.parse('http://127.0.0.1:8000/'),
        headers: <String,String>{
      'Content-Type':'application/json;charset=UTF-8',
        },
    body: jsonEncode(<String,String>{
      'nom':user.nom,
    }));
  }else{

    await http.put(Uri.parse('http://127.0.0.1:8000/'+user.id.toString()),
        headers: <String,String>{
          'Content-Type':'application/json;charset=UTF-8',
        },
        body: jsonEncode(<String,String>{
          'nom':user.nom,
        }));
  }
}

class _MyFormState extends State<MyForm>{
  TextEditingController  idController=new TextEditingController();
  TextEditingController  nomController=new TextEditingController();
  @override
  void initState(){
    super.initState();
    print(this.widget.user.nom);
 setState(() {
   idController.text=this.widget.user.id.toString();
   nomController.text=this.widget.user.nom;
 });
  }
  @override
  Widget build(BuildContext context) {
      return Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              children: [
                Visibility(
                  visible: false,
                  child:TextFormField(
                    decoration: InputDecoration(hintText: 'Entrez id'),
                    controller: idController,
                  ),
                ),
                TextFormField(
                  decoration: InputDecoration(hintText: 'Entrez nom'),
                  controller: nomController,
                ),
                SizedBox(height: 20,),
                MaterialButton(
                  color: Colors.blue,
                    textColor: Colors.white,
                    child: Text("Submit"),
                    minWidth: double.infinity,
                    onPressed: (){
                        setState(() async {
                         await save(User(int.parse(idController.text), nomController.text));
                          Navigator.push(context,
                              new MaterialPageRoute(builder: (context)=>Home(
                                  widgetName: MyList(),
                                  title:'List',
                                  index:0
                              )));
                        });
                    }),

              ],
            ),
          ),
        )
      );
  }

}
