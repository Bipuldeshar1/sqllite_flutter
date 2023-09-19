import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sqllite_crud/dbhelper.dart';
import 'package:sqllite_crud/notesModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DbHelper? dbHelper;

  late Future<List<NotesModel>> noteslist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    loadData();
  }

  loadData() async {
    noteslist = dbHelper!.getNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('crud sql'),
      ),
      body: FutureBuilder(
        future: noteslist,
        builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    dbHelper!.update(NotesModel(
                      id: snapshot.data![index].id,
                      title: 'title',
                      age: 2,
                      description: 'description',
                    ));
                    setState(() {
                      noteslist = dbHelper!.getNotes();
                    });
                  },
                  child: Dismissible(
                    key: ValueKey<int>(snapshot.data![index].id!),
                    direction: DismissDirection.endToStart,
                    background: Container(
                      color: Colors.red,
                      child: Icon(Icons.delete),
                    ),
                    onDismissed: (DismissDirection direction) {
                      setState(() {
                        dbHelper!.delete(snapshot.data![index].id!);
                        noteslist = dbHelper!.getNotes();
                        snapshot.data!.remove(snapshot.data![index]);
                      });
                    },
                    child: Card(
                      child: ListTile(
                          title: Text(snapshot.data![index].title.toString())),
                    ),
                  ),
                );
              },
            );
          } else {
            return Text('no');
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          dbHelper!
              .insert(
            NotesModel(
              title: 'g',
              age: 122,
              description: 'aaa',
            ),
          )
              .then((value) {
            print('added');
            setState(() {
              noteslist = dbHelper!.getNotes();
            });
          }).onError((error, stackTrace) {
            print(error.toString());
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
