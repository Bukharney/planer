import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planer/Db/DBHelper.dart';
import 'package:planer/services/notification_service.dart';
import '../controllers/data_controller.dart';
import '../models/data.dart';
import '../ui/theme.dart';
import '../ui/widget/button.dart';
import '../ui/widget/input_field.dart';

class AddTaskView extends StatefulWidget {
  const AddTaskView({super.key});

  @override
  State<AddTaskView> createState() => _AddTaskViewState();
}

class _AddTaskViewState extends State<AddTaskView> {
  List<int> remindList = [5, 10, 15, 20, 25, 30];
  List<String> repeatList = ["Never", "Daily", "Weekly", "Monthly"];

  String _endTime = "12:30 PM";
  TimeOfDay _isStartTime = const TimeOfDay(hour: 8, minute: 30);
  final TextEditingController _noteController = TextEditingController();
  int _selectedColor = 0;
  DateTime _selectedDate = DateTime.now();
  int _selectedRemind = 5;
  String _selectedRepeat = "Never";
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 30);
  String _startTime = "8:30 AM";
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();

  @override
  void initState() {
    NotificationService().init();
    super.initState();
  }

  _validate() {
    if (_titleController.text.isNotEmpty && _noteController.text.isNotEmpty) {
      _addTaskToDb();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar(
        "Required",
        "All fields are required !",
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.pink,
        backgroundColor: Colors.white,
        icon: const Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
      );
    }
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () async {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
          color: Get.isDarkMode ? Colors.white : Colors.black,
        ),
      ),
      actions: const [
        CircleAvatar(
          backgroundImage: AssetImage("images/profile.png"),
        ),
        SizedBox(width: 20),
      ],
    );
  }

  _getTime(bool strn) async {
    return await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: Get.isDarkMode
                ? const ColorScheme.dark()
                : const ColorScheme.light(
                    primary: Themes.primaryClr,
                  ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        double start = _isStartTime.hour + _isStartTime.minute / 60;
        double picked = value.hour + value.minute / 60;
        if (strn) {
          setState(() {
            _selectedTime = value;
          });
        } else if (!strn && picked > start) {
          setState(() {
            _selectedTime = value;
          });
        } else {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text("Error"),
                content: const Text("End time must be greater than start time"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      "OK",
                      style: TextStyle(
                        color: Colors.deepPurpleAccent[100],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }
      }
    });
  }

  _getDate() {
    return showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2021),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: Get.isDarkMode
                ? const ColorScheme.dark()
                : const ColorScheme.light(
                    primary: Themes.primaryClr,
                  ),
          ),
          child: child!,
        );
      },
    ).then((value) {
      if (value != null) {
        setState(() {
          _selectedDate = value;
          print(_selectedDate);
        });
      }
    });
  }

  _colorPallete() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Color",
          style: titleStyle,
        ),
        const SizedBox(
          height: 12,
        ),
        Wrap(
          children: List<Widget>.generate(
            6,
            (int index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedColor = index;
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.primaries[index],
                    child: _selectedColor == index
                        ? const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 16,
                          )
                        : Container(),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  _addTaskToDb() async {
    try {
      int value = await _taskController.addTask(
        task: Task(
          title: _titleController.text.toString(),
          note: _noteController.text.toString(),
          date: DateFormat.yMd().format(_selectedDate),
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          repeat: _selectedRepeat,
          remind: _selectedRemind,
          isCompleted: 0,
        ),
      );
      _taskController.getTasks();
      _setNoltification(value);
      print("my id is $value");
    } catch (e) {
      print(e);
    }
  }

  _setNoltification(int value) async {
    DateTime time = DateFormat.jm().parse(_startTime.toString());
    await NotificationService().zonedScheduleNotification(
      title: _titleController.text.toString(),
      body: _noteController.text.toString(),
      id: value,
      year: _selectedDate.year,
      month: _selectedDate.month,
      day: _selectedDate.day,
      hour: time.hour,
      minutes: time.minute,
      repeat: _selectedRepeat,
      reminder: _selectedRemind,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Task",
                style: headingStyle,
              ),
              const SizedBox(height: 10),
              InputField(
                title: 'Title',
                hint: 'Enter your title',
                controller: _titleController,
              ),
              InputField(
                title: 'Note',
                hint: 'Enter your note',
                controller: _noteController,
              ),
              InputField(
                title: 'Date',
                hint: DateFormat('dd/MM/yyyy').format(_selectedDate),
                widget: IconButton(
                  onPressed: () async {
                    await _getDate();
                  },
                  icon: const Icon(Icons.calendar_today_outlined),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start Time',
                      hint: _startTime,
                      widget: IconButton(
                        onPressed: () async {
                          await _getTime(true);
                          setState(() {
                            _startTime = _selectedTime.format(context);
                            _isStartTime = _selectedTime;
                          });
                        },
                        icon: const Icon(Icons.access_time_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: InputField(
                      title: 'End Time',
                      hint: _endTime,
                      widget: IconButton(
                        onPressed: () async {
                          await _getTime(false);
                          setState(() {
                            _endTime = _selectedTime.format(context);
                          });
                        },
                        icon: const Icon(Icons.access_time_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Remind",
                      style: titleStyle,
                    ),
                    Container(
                      height: 52,
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonFormField(
                          hint: Text("$_selectedRemind minutes early"),
                          borderRadius: BorderRadius.circular(10),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                          ),
                          items: remindList
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      "$e minutes early",
                                      style: hintStyle,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRemind = value as int;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Repeat",
                      style: titleStyle,
                    ),
                    Container(
                      height: 52,
                      margin: const EdgeInsets.only(top: 8.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey,
                          width: 1.0,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: DropdownButtonFormField(
                          hint: Text(_selectedRepeat),
                          borderRadius: BorderRadius.circular(10),
                          icon: const Icon(
                            Icons.keyboard_arrow_down_outlined,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 20),
                          ),
                          items: repeatList
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(
                                      e,
                                      style: hintStyle,
                                    ),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedRepeat = value as String;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: "Add Task",
                    onTap: () async {
                      await _validate();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
