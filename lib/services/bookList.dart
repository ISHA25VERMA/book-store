import 'dart:convert';

import 'package:http/http.dart';
import 'package:ishaa/models/books.dart';

class BooksList{

  List<Books> BookList = [];

  Future<void> getList() async{
    try{
      Response books = await get(Uri.parse('https://nogozo.com/api/romance-novels/?format=json'));
      var jsonBookList = jsonDecode(books.body);
      List<Map<String, dynamic>> bookList = List.from(jsonBookList);
      // print(bookList);
      int count = bookList.length;
      print(count);

      for(int i = 0; i<count; i++){
        BookList.add(Books.fromJson(bookList[i]));
      }

      print(BookList);

    }catch(e){
      print(e.toString());
      print('error connecting to the json');
    }
  }
}