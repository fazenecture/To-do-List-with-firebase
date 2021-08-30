import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';

class TodoList extends StatefulWidget {
  static String id = 'todo_list';

  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  var dbRef = FirebaseDatabase.instance.reference();
  TextEditingController taskTitle = TextEditingController();
  late bool taskStatus = false;
  late bool isClicked = false;
  late int timeStamp;
  List<Map<dynamic, dynamic>> taskList = [];

  int timeCheck() {
    timeStamp = DateTime.now().millisecondsSinceEpoch;
    return timeStamp;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Material(
          color: Color(0xFFE6E6EC),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
                    'To Do List',
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF19181B),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Container(
                        height: 55,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(46),
                        ),
                        child: TextFormField(
                          controller: taskTitle,
                          cursorColor: Color(0xFF19181B),
                          onFieldSubmitted: (value) {
                            if(taskTitle.text.isNotEmpty){
                              setState(() {
                                timeCheck();
                                dbRef.child('Todo/$timeStamp').update({
                                  'Status': false,
                                  'Title': taskTitle.text,
                                  'Clicked': false,
                                });
                                taskTitle.clear();
                              });
                            }else{
                              Fluttertoast.showToast(msg: 'Add A Task',
                              backgroundColor: Color(0xFF19181B).withOpacity(0.4),
                              );
                            }
                          },
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            hintText: 'Add you task',
                            hintStyle: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.withOpacity(0.6)),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 18.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14.0)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 55,
                      width: 55,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if(taskTitle.text.isNotEmpty){
                            setState(() {
                              timeCheck();
                              dbRef.child('Todo/$timeStamp').update({
                                'Status': false,
                                'Title': taskTitle.text,
                                'Clicked': false,
                              });
                              taskTitle.clear();
                            });
                          }else{
                            Fluttertoast.showToast(msg: 'Add A Task',
                              backgroundColor: Color(0xFF19181B).withOpacity(0.4),
                            );
                          }
                        },
                        icon: Icon(
                          CupertinoIcons.plus,
                          color: Color(0xFF19181B),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                FutureBuilder(
                    future: dbRef.child('Todo').once(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.data.value != null) {
                        var data = snapshot.data.value;
                        // print(data);
                        taskList.clear();
                        List timeStamp = [];
                        Map<dynamic, dynamic> values = snapshot.data.value;
                        values.forEach((key, value) {
                          timeStamp.add(key);
                          taskList.add(value);
                        });
                        return Expanded(
                          child: ListView.builder(
                            itemCount: taskList.length,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              print(taskList[index]['Title']);

                              String gTitle = taskList[index]['Title'];
                              bool gStatus = taskList[index]['Status'];
                              bool gClicked = taskList[index]['Clicked'];

                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Container(
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(15),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Checkbox(
                                          checkColor: Color(0xFF19181B),
                                            overlayColor: MaterialStateColor.resolveWith(
                                                  (states) {
                                                if (states.contains(MaterialState.selected)) {
                                                  return Color(0xFF19181B).withOpacity(0.2); // the color when checkbox is selected;
                                                }
                                                return Color(0xFFE6E6EC).withOpacity(0.2); //the color when checkbox is unselected;
                                              },
                                            ),
                                            fillColor: MaterialStateColor.resolveWith(
                                                  (states) {
                                                if (states.contains(MaterialState.selected)) {
                                                  return Color(0xFFE6E6EC); // the color when checkbox is selected;
                                                }
                                                return Color(0xFFE6E6EC); //the color when checkbox is unselected;
                                              },
                                            ),
                                            focusColor: Color(0xFF19181B),
                                            activeColor: Color(0xFFE6E6EC),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                              side: BorderSide.none
                                            ),
                                            value: gStatus,
                                            onChanged: (value) {
                                              setState(() {
                                                if (gStatus == false) {
                                                  taskStatus = true;
                                                  dbRef
                                                      .child(
                                                          'Todo/${timeStamp[index]}')
                                                      .update({
                                                    'Status': taskStatus,
                                                  });
                                                } else {
                                                  taskStatus = false;
                                                  dbRef
                                                      .child(
                                                          'Todo/${timeStamp[index]}')
                                                      .update({
                                                    'Status': taskStatus,
                                                  });
                                                }
                                              });
                                            }),
                                      ),
                                      Container(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.38,
                                        child: gClicked == true
                                            ? TextFormField(
                                              cursorColor: Color(0xFF19181B),
                                              autofocus: true,
                                              maxLines: 1,
                                              initialValue: gTitle,
                                              style: GoogleFonts.lato(
                                                  fontSize: 15),
                                              decoration:
                                                  InputDecoration(
                                                contentPadding:
                                                    EdgeInsets
                                                        .symmetric(
                                                            vertical: 0,
                                                            horizontal:
                                                                0),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                ),
                                                border:
                                                    OutlineInputBorder(
                                                  borderSide:
                                                      BorderSide.none,
                                                  borderRadius:
                                                      BorderRadius
                                                          .circular(12),
                                                ),
                                              ),
                                              onFieldSubmitted:
                                                  (value) {
                                                setState(() {
                                                  taskTitle.text =
                                                      value;
                                                  gClicked = false;
                                                  dbRef
                                                      .child(
                                                          'Todo/${timeStamp[index]}')
                                                      .update({
                                                    'Title':
                                                        taskTitle.text,
                                                    'Clicked': gClicked,
                                                  });
                                                  taskTitle.clear();

                                                });
                                              },
                                              // onChanged: (value){
                                              //   setState(() {
                                              //     taskTitle.text =
                                              //         value;
                                              //     gClicked = false;
                                              //     dbRef
                                              //         .child(
                                              //         'Todo/${timeStamp[index]}')
                                              //         .update({
                                              //       'Title':
                                              //       taskTitle.text,
                                              //       'Clicked': gClicked,
                                              //     });
                                              //     taskTitle.clear();
                                              //
                                              //   });
                                              // },
                                            )
                                            : GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    gClicked = true;
                                                    dbRef
                                                        .child(
                                                            'Todo/${timeStamp[index]}')
                                                        .update({
                                                      'Clicked': gClicked,
                                                    });
                                                  });
                                                },
                                                child: Text(
                                                  '$gTitle',
                                                  textAlign: TextAlign.left,
                                                  style: GoogleFonts.lato(
                                                      fontSize: 15),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                      ),
                                      SizedBox(
                                        width: MediaQuery.of(context)
                                                .size
                                                .width *
                                            0.24,
                                      ),
                                      IconButton(
                                          onPressed: () {
                                            setState(() {
                                              dbRef
                                                  .child(
                                                      'Todo/${timeStamp[index]}')
                                                  .remove();
                                            });
                                          },
                                          splashColor: Colors.transparent,
                                          icon: Icon(
                                            Icons.delete_outline,
                                            size: 20,
                                            color: Color(0xFF19181B),
                                          )),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        print('asas');
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 100),
                          child: Container(
                            child: Center(
                              child: Text(
                                  'Start By Adding Some Task',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF19181B),
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
