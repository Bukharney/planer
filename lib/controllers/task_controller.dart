import 'package:get/get.dart';

import '../Db/DBHelper.dart';
import '../models/task.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void deleteTask(Task task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void updateTask(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}
