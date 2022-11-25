import 'package:flutter/material.dart';
import 'package:intl/date_symbols.dart';
import 'package:task_list/helper/AnnotationHelper.dart';
import 'package:task_list/model/Annotation.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  var _db = AnnotationHelper();

  void _insertAnnotation() async{

    String title = titleController.text;
    String description = descriptionController.text;

    print("Data: ${DateTime.now().toString()}");

    Annotation annotation = Annotation(
      title, description, 
      DateTime.now().toString()
    );

    int result = await _db.insertAnnotation(annotation);
    print("Id: $result");

    titleController.clear();
    descriptionController.clear();
  }

  void _showRegisterScreen() {

    showDialog(
      context: context, 
      builder: (context) {

        return AlertDialog(
          title: Text("Salvar"),
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Título",
                  hintText: "Digite o título"
                ),
              ),

              TextField(
                controller: descriptionController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  hintText: "Digite a descrição"
                ),
              )
            ]
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: Text("Cancelar")
            ),
            TextButton(
              onPressed: () {

                //Salvar no Database
                _insertAnnotation();
                Navigator.pop(context);
              }, 
              child: Text("Salvar")
            )

          ],
        );
      }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Notas"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Column(
        children: [

        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        child: Icon(Icons.add),  
        onPressed: () => _showRegisterScreen(),
      ),
    );
  }
}