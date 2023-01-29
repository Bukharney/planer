import 'package:get/get.dart';

import '../Db/DBHelper.dart';
import '../models/data.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insertTask(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.readAllTasks();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void deleteTask(Task task) async {
    await DBHelper.deleteTask(task.id!);
    getTasks();
  }

  void updateTask(Task task) async {
    await DBHelper.updateTask(task);
    getTasks();
  }
}

class ScheduleController extends GetxController {
  var scheduleList = <Schedule>[].obs;

  Future<int> addSchedule({Schedule? schedule}) async {
    return await DBHelper.insertSchedule(schedule);
  }

  void getSchedule() async {
    List<Map<String, dynamic>> schedule = await DBHelper.readAllSchedules();
    scheduleList.assignAll(schedule.map((e) => Schedule.fromJson(e)).toList());
  }

  void deleteSchedule(Schedule schedule) async {
    await DBHelper.deleteSchedule(schedule.id!);
    getSchedule();
  }
}
