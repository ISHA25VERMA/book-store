import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ishaa/configuration.dart';
import 'package:ishaa/models/books.dart';
import 'package:ishaa/services/bookList.dart';

void main() {
  runApp(
      MaterialApp(
        home: BookApp(),
      ));
}

class BookApp extends StatefulWidget {
  const BookApp({Key? key}) : super(key: key);

  @override
  _BookAppState createState() => _BookAppState();
}

class _BookAppState extends State<BookApp> {

  ScrollController controller = ScrollController();
  bool closeTopCarousel = false;

  String query = '';

  // TextEditingController _searchController = TextEditingController();

  late List<Books> books = [];
  BooksList booksList =BooksList();

  setUpBookList() async{
    await booksList.getList();
    setState(() {

      if (query == ''){
        books = booksList.BookList;
      }else{
        books = booksList.BookList.where((element) => element.name.startsWith(query)).toList();
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setUpBookList();
    controller.addListener(() {
      setState(() {
        closeTopCarousel = controller.offset > 50 ;
      });
    });
    // _searchController.addListener(onSearchChanged());
  }


  @override
  Widget build(BuildContext context) {



    if (query == '' || query.isEmpty){
      books = booksList.BookList;
    }else{
      books = booksList.BookList.where((element) => element.name.toLowerCase().startsWith(query.toLowerCase())).toList();
    }

    return Scaffold(
      backgroundColor: Colors.teal[50],
      appBar: buildAppBar(),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(child: Text('Heading'))
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              padding : EdgeInsets.fromLTRB(20.0,   10.0, 20.0, 0.0),
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: SearchRow(),
            ),
            AnimatedContainer(
              duration:  const Duration(milliseconds: 200),
              height: closeTopCarousel? 0: 80.0,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Container(
                    margin: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: SizedBox(
                        height: 80.0,
                        width: double.infinity,
                        child: CarouselSlider(
                          items: [
                            Image.asset('assets/c1.webp',height: 80,),
                            Image.asset('assets/c2.webp', height: 80.0,)
                          ],
                          options: CarouselOptions(),
                        )
                      // Carousel(
                      //   dotSize: 4.0,
                      //   dotColor: Colors.black,
                      //   dotBgColor: Colors.transparent,
                      //   dotSpacing: 14,
                      //   dotVerticalPadding: 1.0,
                      //   indicatorBgPadding: 10.0,
                      //   dotPosition: DotPosition.bottomRight,
                      //   images: [
                      //     Image.asset(
                      //       'assets/c1.webp',
                      //     ),
                      //     Image.asset(
                      //       'assets/c2.webp',
                      //     ),
                      //     Image.asset(
                      //       'assets/c2.webp',
                      //     )
                      //   ],
                      // ),
                    ),
                  )
                ],
              ),
            ),
            Container(
                height: 110,
                child: ListView.builder(itemBuilder: (context, index){
                  return Container(
                    margin: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color:  categories[index]['color'],
                        borderRadius: BorderRadius.circular(20.0)
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.0),
                          height: 70.0,
                          width: 85.0,
                          child:  Image.asset(categories[index]['iconPath'],
                            height: 50.0,
                            width: 50.0,
                          ),
                        ),
                        Text(
                          categories[index]['name'],
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,

                )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Books for Romance',
                style: TextStyle(
                  fontSize: 30.0,
                ),
              ),
            ),
            gridBooks(),
          ],
        ),
      ),
    );
  }

  Expanded gridBooks() {
    return Expanded(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10.0),
          child: GridView.builder(
              controller: controller,
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: books.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,
                childAspectRatio: (50/85.0),
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
              ),
              itemBuilder: (context, index){
                return Card(
                  elevation: 2.0,
                  shadowColor: Colors.black,
                  child: SizedBox(
                    height: double.infinity,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 10.0),
                          child: Image.network(books[index].imgUrl,
                            height: 170,
                            // height:250.0,
                            // width: 130.0,
                          ),
                        ),
                        Column(
                          children: [
                            Center(child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(books[index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0
                                ),
                              ),
                            )),

                            Padding(
                              padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 5.0),
                              child: Row(
                                children: [
                                  Text('week Rent: '+'Rs '+ books[index].weekRent +' ' ,
                                    style: TextStyle(
                                        color: Colors.grey[600]
                                    ),),
                                  Text('Rs'+ books[index].mrp ,
                                    style: TextStyle(
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),
                            )

                          ],

                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 5.0, 5.0),
                          child: Row(
                            children: [
                              Text('week Rent: '+'Rs '+ books[index].weekRent +' ' ,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 5.0
                                ),),

                            ],
                          ),
                        )

                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  Row SearchRow() {
    return Row(
      children: [
        SizedBox(width: 10.0,),
        Icon(Icons.search),
        SizedBox(width: 10.0,),
        Expanded(child: TextField(
          onChanged: (val){
            setState(() {
              query = val;
            });
          },
          decoration: InputDecoration(
            hintText: 'Search books ...',
            enabledBorder: null,
          ),
        )),
        SizedBox(width: 10.0),
        IconButton(onPressed: (){}, icon: Icon(Icons.mic)),
      ],
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      flexibleSpace: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal.shade200, Colors.teal.shade50],
            )
        ),
      ),
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      title: Image.asset(
        'assets/logo.png',
        width: 70.0,
      ),
      actions: [
        IconButton(onPressed: (){}, icon: Icon(Icons.add_shopping_cart_sharp))
      ],
      elevation: 0.0,
    );
  }
}
