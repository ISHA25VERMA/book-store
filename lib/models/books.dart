class Books{

  String imgUrl;
  String name;
  String weekRent;
  String mrp;

  Books({required this.imgUrl, required this.name, required this.mrp, required this.weekRent});

  factory Books.fromJson(Map<String, dynamic> parsedJson){
    return new Books(imgUrl: parsedJson['image'], name: parsedJson['name'], mrp: parsedJson['mrp'], weekRent: parsedJson['one_week_rent_price']);
  }

}