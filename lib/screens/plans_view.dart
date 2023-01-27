import 'package:date_picker_timeline/date_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:planer/services/notification_service.dart';
import '../controllers/task_controller.dart';
import '../models/task.dart';
import '../services/theme_service.dart';
import '../ui/theme.dart';
import '../ui/widget/button.dart';
import '../ui/widget/task_file.dart';
import 'add_task_bar.dart';

class PlansView extends StatefulWidget {
  const PlansView({super.key});

  @override
  State<PlansView> createState() => _PlansViewState();
}

class _PlansViewState extends State<PlansView> {
  final TaskController _taskController = Get.put(TaskController());
  late DateTime _selectedDate;
  var myFormat = DateFormat('yyyy-MM-dd');
  bool status = true;

  int click = 0;

  void _onItemTaped(int index) {
    setState(() {
      click = index;
    });
  }

  @override
  void initState() {
    _taskController.getTasks();
    setState(() {
      status = ThemeService().loadThemeFromBox();
      _selectedDate = DateTime.now();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaksBar(),
          _addDateBar(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: subHeadingStyle,
                    ),
                    Text(
                      "Today",
                      style: headingStyle,
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: MyButton(
                  label: "+ Add Task",
                  onTap: () async {
                    await Get.to(() => const AddTaskView());
                    _taskController.getTasks();
                  },
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            child: DatePicker(
              DateTime.now(),
              width: 60,
              height: 90,
              initialSelectedDate: DateTime.now(),
              selectionColor: Themes.primaryClr,
              selectedTextColor: Colors.white,
              dateTextStyle: GoogleFonts.lato(
                textStyle: status
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      )
                    : const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                      ),
              ),
              dayTextStyle: GoogleFonts.lato(
                textStyle: status
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )
                    : const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
              ),
              monthTextStyle: GoogleFonts.lato(
                textStyle: status
                    ? const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      )
                    : const TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                      ),
              ),
              onDateChange: (date) {
                setState(() {
                  _selectedDate = date;
                });
              },
            ),
          ),
          Container(
            child: _showTasks(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: 'Plans',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.view_quilt_rounded),
            label: 'Schedule',
          ),
        ],
        elevation: 10,
        currentIndex: click,
        onTap: _onItemTaped,
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeService().switchTheme();
          setState(() {
            status = !Get.isDarkMode;
          });
        },
        child: Icon(status ? Icons.wb_sunny_rounded : Icons.nightlight_rounded,
            size: 20, color: status ? Colors.white : Colors.black),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _addDateBar() {
    return Container();
  }

  _addTaksBar() {
    return Container();
  }

  _showTasks() {
    return Expanded(
      child: Obx(
        () {
          return ListView.builder(
            itemCount: _taskController.taskList.length,
            itemBuilder: (_, index) {
              print("Item builded");
              Task task = _taskController.taskList[index];
              print(task.toJson());
              DateTime date = DateFormat.yMd().parse(task.date.toString());
              if (task.repeat == 'Daily') {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (_selectedDate.difference(date).inDays % 7 == 0 &&
                  task.repeat == 'Weekly') {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (date.difference(_selectedDate).inDays == 0 &&
                  task.repeat == 'Monthly') {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else if (date.day == _selectedDate.day &&
                  task.repeat == 'Never') {
                return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                    child: FadeInAnimation(
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              _showBottomSheet(context, task);
                            },
                            child: TaskTile(task),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              } else {
                print('Found nothing');
                return Container();
              }
            },
          );
        },
      ),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.only(top: 5),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.25
            : MediaQuery.of(context).size.height * 0.35,
        color: Get.isDarkMode ? Themes.darkGreyClr : Themes.white,
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 5,
              width: 120,
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetBotton(
                    context: context,
                    label: "Mark as Completed",
                    onTap: () {
                      _taskController.updateTask(task.id!);
                      NotificationService().cancelNotification(task.id!);
                      Get.back();
                    },
                    color: Themes.primaryClr,
                  ),
            _bottomSheetBotton(
              context: context,
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                NotificationService().cancelNotification(task.id!);
                Get.back();
              },
              color: Colors.red[400]!,
            ),
            const SizedBox(
              height: 20,
            ),
            _bottomSheetBotton(
              context: context,
              label: "Close",
              onTap: () {
                Get.back();
              },
              color: Colors.white,
              isClose: true,
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  _bottomSheetBotton({
    required String label,
    required Function()? onTap,
    required Color color,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode
                    ? Colors.grey[600]!
                    : Colors.grey[200]!
                : color,
          ),
          color: isClose == true ? Colors.white : color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Center(
          child: Text(
            label,
            style: isClose
                ? titleStyle.copyWith(
                    color: Colors.black,
                  )
                : titleStyle.copyWith(
                    color: Colors.white,
                  ),
          ),
        ),
      ),
    );
  }

  _showSchedule() {
    return Container();
  }

  _testNoti() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: MyButton(
        label: "test",
        onTap: () {
          NotificationService().showNotification(
            title: "test",
            body: "test test",
          );
        },
      ),
    );
  }
}
