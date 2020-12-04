import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import './adddata.dart';
import 'detail.dart';

class MyClass {
  int word1;
  String word2;
int id;
  MyClass(this.word1, this.word2, this.id);
}

class DataList with ChangeNotifier {}



void main() {
  runApp(new MaterialApp(
    title: "Qamoqxona",
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => new _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController editingController = TextEditingController();
  List<MyClass> words = [];
int nameSort=1;
bool increment=false;

  @override
  Widget build(BuildContext context) {
  Future<List> getData() async {
    final response =
    await http.get("https://shaggiest-steeples.000webhostapp.com/getFayoz.php");
    return json.decode(response.body);
  }
    return new Scaffold(
      backgroundColor: Colors.white70,
      appBar: new AppBar(
        centerTitle: true,
        backgroundColor: Colors.black54,
        title: new Text("Mahbuslar ro'yhati".toUpperCase()),
      ),
      floatingActionButton: new FloatingActionButton(
        backgroundColor: Colors.black54,
          child: new Icon(Icons.add),
          onPressed: () async =>await Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddData()))
                  .then((value) {
       setState(() {

       });
          })
      ),
      body: new FutureBuilder<List>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);
           if(snapshot.hasData){
             List list=snapshot.data;
             words.clear();
             list.forEach((element) {
               words.add(MyClass(int.parse(element['post_body']), element['post_header'], int.parse(element['id'])));
          });
             switch(nameSort){
               case 1:{ words.sort((a, b)=> increment ? a.id.compareTo(b.id) : b.id.compareTo(a.id));}
               break;
               case 2:{ words.sort((a, b)=> increment ? a.word2.compareTo(b.word2) : b.word2.compareTo(a.word2));}
               break;
               case 3:{ words.sort((a, b)=> increment ? a.word1.compareTo(b.word1) : b.word1.compareTo(a.word1));}
               break;
             }
          return new Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: editingController,
                  decoration: InputDecoration(
                    hintText: 'Qidiruv uchun shu yerni bosing',
                  ),
                  onChanged: (value) {
                    setState(() {

                    });
                  },
                ),
              ),
              Row(
                children: [
                  FlatButton(

                    child: Text(
                        "Kamayish"
                    ),
                    onPressed: (){
                      setState(() {
                        increment=false;
                      });
                    },
                    color: increment ? Colors.transparent : Colors.green,
                  ),
                  FlatButton(
                    color: increment ? Colors.green : Colors.transparent,
                    child: Text(
                        "O'sish"
                    ),
                    onPressed: (){
                      setState(() {
                      increment=true;
                      });
                    },
                  ),
                ],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              ),
              Row(
                children: [
                  FlatButton(

                    child: Text(
                        "Id"
                    ),
                    onPressed: (){
                      setState(() {
                        nameSort=1;


                      });
                    },
                    color: nameSort==1? Colors.red : Colors.transparent,
                  ),
                  FlatButton(
                    color: nameSort==2? Colors.red : Colors.transparent,
                    child: Text(
                        "Ismi Familiyasi"
                    ),
                    onPressed: (){
                      setState(() {
                        nameSort=2;


                      });
                    },
                  ),
                  FlatButton(
                    color: nameSort==3? Colors.red : Colors.transparent,
                    child: Text(
                        "jazo muddati"
                    ),
                    onPressed: (){
                      setState(() {
                        nameSort=3;

                      });
                    },
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: words.length,
                    itemBuilder: (context, index) {
                      if (editingController.text.isEmpty) {
                        return ListTile(
                          onTap: (){
                            Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context)=> new Detail(words: words , index: index,)
                                )
                            );
                          },
                          title: Text('${words[index].id}.          ${words[index].word2}'),

                          trailing:Text('${words[index].word1} yil'),
                        );
                      } else if (
                          words[index]
                              .word2
                              .toLowerCase()
                              .contains(editingController.text)) {
                        return ListTile(
                          title:  Text('${words[index].id}.          ${words[index].word2}'),
                          onTap: (){
                            Navigator.of(context).push(
                                new MaterialPageRoute(
                                    builder: (BuildContext context)=> new Detail(words: words , index: index,)
                                )
                            );
                          },
                          trailing:Text('${words[index].word1} yil'),
                        );
                      } else {
                        return Container();
                      }
                    }),
              )
            ],
          );
           }else{
    return new Center(
    child: new CircularProgressIndicator(),
    );
    }
        },
      ),
    );
  }
}
