import 'package:flutter/material.dart';
import 'package:task_list/helper/AnnotationHelper.dart';
import 'package:task_list/model/Annotation.dart';
import "package:intl/intl.dart";
import "package:intl/date_symbol_data_local.dart";
import "dart:ui";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _db = AnnotationHelper();
  List<Annotation> annotations = [];

  void _insertUpdateAnnotation({Annotation? selectedAnnotation}) async{

    String title = titleController.text;
    String description = descriptionController.text;

    if (selectedAnnotation == null) {
      Annotation annotation = Annotation(
        title, description,
        DateTime.now().toString(),
        annotations.isNotEmpty ? annotations.last.priority! + 1 : 1
      );

      int result = await _db.insertAnnotation(annotation);
    } else {
      selectedAnnotation.title = title;
      selectedAnnotation.description = description;
      selectedAnnotation.data = DateTime.now().toString();

      int result = await _db.updateAnnotation(selectedAnnotation);
    }

    titleController.clear();
    descriptionController.clear();

    _getAnnotations();
  }

  void _getAnnotations() async {
    List results = await _db.getAnnotations();
    annotations.clear();

    for (var item in results) {
      Annotation annotation = Annotation.fromMap(item);
      annotations.add(annotation);
    }

    setState(() {
      
    });
  }

  _removeAnnotation(int? id) async {
    await _db.deleteAnnotation(id!);

    _getAnnotations();
  }

  _formatData(String data) {
    initializeDateFormatting("en_US", "");

    var formatter = DateFormat.yMMMMd("en_US");

    DateTime newDate = DateTime.parse(data);
    return formatter.format(newDate);
  }

  void _showRegisterScreen({Annotation? annotation}) {
    String saveUpdateText = "";

    if (annotation == null) {
      titleController.text = "";
      descriptionController.text = "";
      saveUpdateText = "Save";
    } else {
      titleController.text = annotation.title!;
      descriptionController.text = annotation.description!;
      saveUpdateText = "Update";
    }


    showDialog(
      context: context, 
      builder: (context) {

        return AlertDialog(
          title: Text(saveUpdateText),
          
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Title",
                  hintText: "Ex: drink water"
                ),
              ),

              TextField(
                controller: descriptionController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: "Description",
                  hintText: "Ex: 300ml"
                ),
              )
            ]
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), 
              child: const Text("Cancel")
            ),
            TextButton(
              onPressed: () {
                //_insertAnnotation();
                _insertUpdateAnnotation(selectedAnnotation: annotation);
                Navigator.pop(context);
              }, 
              child: Text(saveUpdateText)
            )

          ],
        );
      }
    );

  }

  _showDismissConfirmation(int index) {
    showDialog(
      context: context, 
      builder: (context) {

        return AlertDialog(
          title: const Text("Confirm Dismiss"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, 
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _removeAnnotation(annotations[index].id);
                  annotations.removeAt(index);
                });
                Navigator.pop(context);
              }, 
              child: const Text("Delete"),
            )
          ],
        );
      }
    );
  }

  @override
  void initState() {
    super.initState();
    _getAnnotations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task List"),
        centerTitle: true,
        backgroundColor: const Color(0xff1693a7),
      ),
      body: ColoredBox(
        color: const Color(0xfff8fcc1),
        child: Column(
          children: [
             Expanded (
              child: ReorderableListView.builder(
                proxyDecorator: proxyDecorator,
                onReorder: (int oldIndex, int newIndex) {
                  setState(() {
                    if (oldIndex < newIndex) {
                      newIndex -= 1;
                    }
                    Annotation item = annotations.removeAt(oldIndex);
                    annotations.insert(newIndex, item);
                  });
                  for (int i = 0; i < annotations.length; i++) {
                    Annotation annotation = annotations[i];
                    annotation.priority = i;
                    _db.updateAnnotation(annotation);
                  }
                },
                itemCount: annotations.length,
                itemBuilder: (context, index) {
                  final item = annotations[index];
      
                  return Dismissible(
                    background: leftBackground(),
                    secondaryBackground: rightBackground(),
                    key: Key(item.data!),
                    confirmDismiss: (direction) async {
                      if (direction == DismissDirection.startToEnd) {
                        _showDismissConfirmation(index);
                      } else {
                        _showRegisterScreen(annotation: item);
                      }
                      return null;
                    },
                    child: ListTile(
                      title: Text(item.title!),
                      subtitle: Text("${_formatData(item.data!)} - ${item.description}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showRegisterScreen(annotation: item);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 16),
                              child: Icon(
                                Icons.edit,
                                color: Color(0xff4caf50),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              _removeAnnotation(item.id);
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 0),
                              child: Icon(
                                Icons.remove_circle,
                                color: Color(0xffcc0c39),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }
              )
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff4caf50),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),  
        onPressed: () => _showRegisterScreen(),
      ),
    );
  }

  Widget leftBackground() {
    return Container(
      color: const Color(0xffcc0c39),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: const <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              "Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Widget rightBackground() {
    return Container(
      color: const Color(0xff4caf50),
      child: Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const <Widget>[
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              "Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget proxyDecorator (Widget child, int index, Animation<double> animation) {
    return AnimatedBuilder(
      animation: animation,
      builder: (BuildContext context, Widget? child) {
        final double animValue = Curves.easeInOut.transform(animation.value);
        final double elevation = lerpDouble(0, 6, animValue)!;
        return Material(
          elevation: elevation,
          color: const Color(0xffc8cf02),
          shadowColor: const Color(0xff1693a7),
          child: child,
        );
      },
      child: child,
    );
  }
}


// #cc0c39
// #4caf50
// #c8cf02
// #f8fcc1
// #1693a7