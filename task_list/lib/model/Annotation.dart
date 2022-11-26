class Annotation {
  int? id;
  String? title;
  String? description;
  String? data;
  int? priority;

  Annotation(this.title, this.description, this.data, this.priority);


  Annotation.fromMap(Map map) {
    this.id = map["id"];
    this.title = map["title"];
    this.description = map["description"];
    this.data = map["date"];
    this.priority = map["priority"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "title": this.title,
      "description": this.description,
      "date": this.data,
      "priority": this.priority,
    };

    map["id"] ??= this.id;

    return map;
  }  
}