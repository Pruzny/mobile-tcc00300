class Advertisement {
  int? id;
  String? state;
  String? category;
  String? title;
  String? price;
  String? telephone;
  String? description;
  var photo;

  Advertisement({required this.category, required this.title, required this.price, required this.telephone, required this.description, this.photo});


  Advertisement.fromMap(Map map) {
    this.id = map["id"];
    this.state = map["state"];
    this.category = map["category"];
    this.title = map["title"];
    this.price = map["price"];
    this.telephone = map["telephone"];
    this.description = map["description"];
    this.photo = map["photo"];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "state": this.state,
      "category": this.category,
      "title": this.title,
      "price": this.price,
      "telephone": this.telephone,
      "description": this.description,
    };

    map["id"] ??= this.id;
    map["photo"] ??= this.photo;

    return map;
  }  
}