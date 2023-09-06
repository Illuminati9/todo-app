import 'package:http/http.dart' as http;
import 'package:todo/task.dart';

class Service {
  Future<List<Task>?> getTasks() async {
    final response =
        await http.get(Uri.parse("https://todoapp-7jzr.onrender.com/todos"));
    print(response);
    if (response.statusCode == 200) {
      var json = response.body;
      return taskFromJson(json);
    }
  }

  Future<List<Task>?> addTask(String title, String description) async {
    final url = "https://todoapp-7jzr.onrender.com/todo/new";
    final response = await http.post(Uri.parse(url),body: {"title":title,"description":description});
    final response1 =
        await http.get(Uri.parse("https://todoapp-7jzr.onrender.com/todos"));

    if (response1.statusCode == 200) {
      var json = response1.body;
      if (json != null) {
        return taskFromJson(json);
      } else {
        throw Exception('Response body is null');
      }
    }
  }

  Future<List<Task>?> deleteTask(String id) async {
    print("delete");
    final url = "https://todoapp-7jzr.onrender.com/todo/delete/" + id;
    final response = await http.delete(Uri.parse(url));
    final response1 =
        await http.get(Uri.parse("https://todoapp-7jzr.onrender.com/todos"));
    if (response1.statusCode == 200) {
      var json = response1.body;
      if (json != null) {
        return taskFromJson(json);
      } else {
        throw Exception('Response body is null');
      }
    }
  }

  Future<List<Task>?> editTask(
      String id, String title, String description) async {
    print('${id} ${title} ${description}');
    final url = "https://todoapp-7jzr.onrender.com/todo/update/" + id;
    final response = await http.put(Uri.parse(url),body: {"title":title,"description":description});
    final response1 =
        await http.get(Uri.parse("https://todoapp-7jzr.onrender.com/todos"));

    if (response1.statusCode == 200) {
      var json = response1.body;
      if (json != null) {
        return taskFromJson(json);
      } else {
        throw Exception('Response body is null');
      }
    }
  }

  Future<List<Task>?> completeTask(String id) async {
    final url = 'https://todoapp-7jzr.onrender.com/todo/complete/' + id;
    final response = await http.get(Uri.parse(url));
    final response1 =
        await http.get(Uri.parse("https://todoapp-7jzr.onrender.com/todos"));

    if (response1.statusCode == 200) {
      var json = response1.body;
      if (json != null) {
        return taskFromJson(json);
      } else {
        throw Exception('Response body is null');
      }
    }
  }
}
