import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo/search.dart';
import 'package:todo/task.dart';
import 'services/services.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(useMaterial3: true),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Task>? tasks=[];
  final key = FormState();
  final TextEditingController _task = TextEditingController();
  final TextEditingController _description = TextEditingController();

  var isLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  fetchData() async {
    tasks = await Service().getTasks();
    setState(() {
      isLoaded = true;
    });
    print(tasks?[0].title);
  }

  void _showDialog() {
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Add Task'),
        content: Form(
          // key: ,
          child: SizedBox(
            height: MediaQuery.of(context).size.height / 5,
            child: Column(children: <Widget>[
              TextFormField(
                controller: _task,
                decoration: InputDecoration(
                  hintText: 'Enter Task Title',
                  labelText: 'Title',
                ),
              ),
              TextFormField(
                controller: _description,
                decoration: InputDecoration(
                  hintText: 'Enter Task Description',
                  labelText: 'Description',
                ),
              ),
            ]),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              _task.clear();
              _description.clear();
              Navigator.pop(context, 'CANCEL');
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await Service().addTask(_task.text, _description.text);
              List<Task>? newTasks = await Service().getTasks();
              setState(() {
                tasks = newTasks;
              });
              Navigator.pop(context, 'OK');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                // print("------dsf----");
                print(tasks);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchPage(tasks: tasks)));
              },
              icon: Icon(Icons.search))
        ],
      ),
      body: Column(
        children: <Widget>[
          Container(
              child: Text(
            "Your tasks",
            style: TextStyle(fontSize: 25),
          )),
          Visibility(
            visible: isLoaded,
            child: Visibility(
              visible: tasks!.length>0,
              replacement: Center(
                child: Text(
                  "Add a task now",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              child: Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: tasks?.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                            tileColor: tasks![index].iscompleted ? Colors.green.shade100: Colors.deepPurple.shade100,
                            leading: Checkbox(
                              onChanged: (bool? value) async {
                                await Service().completeTask(tasks![index].id);
                                List<Task>? newTasks = await Service().getTasks();
                                setState(() {
                                  tasks = newTasks;
                                });
                              },
                              value: tasks?[index].iscompleted,
                            ),
                            title: Text(
                              tasks![index].title,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              tasks![index].description,
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Colors.grey.shade700,
                              ),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    final TextEditingController _title1 =
                                        TextEditingController();
                                    final TextEditingController _description1 =
                                        TextEditingController();
                                    _title1.text = tasks![index].title;
                                    _description1.text =
                                        tasks![index].description;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Edit Task'),
                                        content: SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height /
                                                  5,
                                          child: Column(children: <Widget>[
                                            TextFormField(
                                              controller: _title1,
                                              decoration: InputDecoration(
                                                hintText: 'Enter Task Title',
                                                labelText: 'Title',
                                              ),
                                            ),
                                            TextFormField(
                                              controller: _description1,
                                              decoration: InputDecoration(
                                                hintText:
                                                    'Enter Task Description',
                                                labelText: 'Description',
                                              ),
                                            ),
                                          ]),
                                        ),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              _title1.clear();
                                              _description1.clear();
                                              Navigator.pop(context, 'Cancel');
                                            },
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () async {
                                              await Service().editTask(
                                                  tasks![index].id,
                                                  _title1.text,
                                                  _description1.text);
                                              List<Task>? newTasks =
                                                  await Service().getTasks();
                                              setState(() {
                                                tasks = newTasks;
                                              });
                                              Navigator.pop(context, 'OK');
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                                IconButton(
                                    onPressed: () async {
                                      
                                      await Service()
                                          .deleteTask(tasks![index].id);
                                      List<Task>? newTasks =
                                          await Service().getTasks();
                                      setState(() {
                                        tasks = newTasks;
                                        
                                      });
                                    },
                                    icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            ),
            replacement: Container(
              alignment: Alignment.center,
              child:
                  CircularProgressIndicator(backgroundColor: Colors.deepPurple),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // onPressed: () {
        //   Navigator.push(
        //       context, MaterialPageRoute(builder: (context) => NewTask()));
        // },
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('Add Task'),
              content: Form(
                // key: ,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 5,
                  child: Column(children: <Widget>[
                    TextFormField(
                      controller: _task,
                      decoration: InputDecoration(
                        hintText: 'Enter Task Title',
                        labelText: 'Title',
                      ),
                    ),
                    TextFormField(
                      controller: _description,
                      decoration: InputDecoration(
                        hintText: 'Enter Task Description',
                        labelText: 'Description',
                      ),
                    ),
                  ]),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    _task.clear();
                    _description.clear();
                    Navigator.pop(context, 'CANCEL');
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await Service().addTask(_task.text, _description.text);
                    print('Hello');
                    List<Task>? newTasks = await Service().getTasks();
                    setState(() {
                      tasks = newTasks;
                    });
                    _task.clear();
                    _description.clear();
                    print('hello');
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
