// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:udemy_flutter/modules/archived_tasks/archived_tasks_screen.dart';
import 'package:udemy_flutter/modules/done_tasks/done_tasks_screen.dart';
import 'package:udemy_flutter/modules/new_tasks/new_tasks_screen.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({Key? key}) : super(key: key);

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

// 1. create database
// 2. create tables
// 3. open database
// 4. insert database
// 5. get from database
// 6. update in database
// 7. delete from database


class _HomeLayoutState extends State<HomeLayout> {
  int currentIndex = 0;
  List<Widget> screens =
  [
    NewTasksScreen(),
    DoneTasksScreen(),
    ArchivedTasksScreen(),
  ];
  List<String> titles =
  [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

   late Database database;

  @override
  void initState()
  {
    super.initState();
    createDatabase();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          titles[currentIndex],
        ),
      ),
      body:screens[currentIndex] ,
      floatingActionButton: FloatingActionButton(
        onPressed: ()
        {
          insertToDatabase();

       },
        child: Icon(
          Icons.add,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Hint : not used shifting
       currentIndex: currentIndex,
        onTap: (index)
        {
          setState(() {
            currentIndex = index;
          });
          },
        items:
        [
         BottomNavigationBarItem(
             icon:Icon(
             Icons.menu,
             ),
           label: 'Tasks',
         ),
         BottomNavigationBarItem(
             icon:Icon(
             Icons.check_circle_outline,
             ),
           label: 'Done',
         ),
         BottomNavigationBarItem(
             icon:Icon(
             Icons.archive_outlined,
             ),
           label: 'Archived',
         ),

        ],
      ),
    );
  }

  Future<String> getName() async
  {
    return 'Ahmed Ali';
  }

  void createDatabase() async
  {
    database = await openDatabase(
     'todo.db',
     version : 1,
     onCreate: (database, version)
     {
      print('database created');
       database.execute('CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, data TEXT , time TEXT, status TEXT )').then((value)
      {
        print('table created');
      }).catchError((error)
      {
         print ('Error when Creating Table ${error.toString()}');

      });
     },
     onOpen: (database)
       {
         print('database opened');
       },
   );
   print(database);
  }
  void insertToDatabase() async
  {
  await database.transaction((txn) async
    {
      txn.rawInsert(
          'INSERT INTO tasks(title, date, time, status) VALUES("first task","02222", "891","new")'
      )
          .then((value) {
        print('$value inserted successfully');
      }).catchError((error) {
        print('Error when Inserting New Record ${error.toString()}');
      });

      return null ;
    });
  }

}
