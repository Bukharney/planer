import 'package:get/get.dart';

import '../Db/ScheduleDBHelper.dart';
import '../Db/TaskDBHelper.dart';
import '../models/data.dart';

class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  Future<int> addTask({Task? task}) async {
    return await TaskDBHelper.insert(task);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await TaskDBHelper.query();
    taskList.assignAll(tasks.map((e) => Task.fromJson(e)).toList());
  }

  void deleteTask(Task task) async {
    await TaskDBHelper.delete(task);
    getTasks();
  }

  void updateTask(int id) async {
    await TaskDBHelper.update(id);
    getTasks();
  }
}

class ScheduleController extends GetxController {
  var scheduleList = <Schedule>[].obs;

  Future<int> addSchedule({Schedule? schedule}) async {
    return await ScheduleDBHelper.insert(schedule);
  }

  void getSchedule() async {
    List<Map<String, dynamic>> schedule = await ScheduleDBHelper.query();
    scheduleList.assignAll(schedule.map((e) => Schedule.fromJson(e)).toList());
  }

  void deleteSchedule(Schedule schedule) async {
    await ScheduleDBHelper.delete(schedule);
    getSchedule();
  }
}
