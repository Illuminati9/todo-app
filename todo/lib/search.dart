import 'package:flutter/material.dart';
import 'package:todo/main.dart';
import 'package:todo/services/services.dart';
import 'package:todo/task.dart';

class SearchPage extends StatefulWidget {
  List<Task>? tasks;
  SearchPage({super.key, required this.tasks});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _search = TextEditingController();

  List<Task>? sortedTasks = <Task>[];
  List<Task>? sortedTasks2 = <Task>[];

  sorted(String value) {
    // setState(() {
    //   sortedTasks = widget.tasks;
    // });
    for (int i = 0; i < widget.tasks!.length; i++) {
      if (widget.tasks![i].title.toLowerCase().contains(value.toLowerCase())) {
        sortedTasks2!.add(widget.tasks![i]);
      }
    }
    setState(() {
      sortedTasks = sortedTasks2;
    });
    sortedTasks2 = [];
  }

  bool deleteLoader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _search,
                onChanged: (value) {
                  sorted(value);
                },
                decoration: InputDecoration(
                    prefixIcon: IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                            (route) => false);
                      },
                    ),
                    border: OutlineInputBorder(),
                    labelText: 'Search',
                    hintText: 'Search here....'),
              ),
              Visibility(
                visible: sortedTasks!.length != 0,
                replacement: Text('Search for tasks now'),
                child: Expanded(
                  child: ListView.builder(
                      itemCount: sortedTasks!.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              onChanged: (bool? value) async {
                                await Service()
                                    .completeTask(sortedTasks![index].id);
                                List<Task>? newTasks =
                                    await Service().getTasks();
                                setState(() {
                                  widget.tasks = newTasks;
                                });
                              },
                              value: sortedTasks?[index].iscompleted,
                            ),
                            title: Text(sortedTasks![index].title),
                            subtitle: Text(sortedTasks![index].description),
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
                                    _title1.text = sortedTasks![index].title;
                                    _description1.text =
                                        sortedTasks![index].description;
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Edit Task'),
                                        content: SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
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
                                                  sortedTasks![index].id,
                                                  _title1.text,
                                                  _description1.text);
                                              List<Task>? newTasks =
                                                  await Service().getTasks();
                                              setState(() {
                                                widget.tasks = newTasks;
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
                                      setState(() {
                                        deleteLoader = true;
                                      });
                                      await Service()
                                          .deleteTask(sortedTasks![index].id);
                                      List<Task>? newTasks =
                                          await Service().getTasks();
                                      setState(() {
                                        sortedTasks = newTasks;
                                        deleteLoader = false;
                                      });
                                    },
                                    icon: deleteLoader
                                        ? CircularProgressIndicator()
                                        : Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ))
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
