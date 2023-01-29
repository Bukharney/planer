import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:planer/services/notification_service.dart';
import '../Db/DBHelper.dart';
import '../controllers/data_controller.dart';
import '../models/data.dart';
import '../ui/theme.dart';
import '../ui/widget/button.dart';
import '../ui/widget/input_field.dart';

class AddSheduleView extends StatefulWidget {
  const AddSheduleView({super.key});

  @override
  State<AddSheduleView> createState() => _AddSheduleViewState();
}

class _AddSheduleViewState extends State<AddSheduleView> {
  List<String> dayList = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];

  List<int> remindList = [5, 10, 15, 20, 25, 30];

  final TextEditingController _detaillController = TextEditingController();
  String _endTime = "12:30 PM";
  TimeOfDay _isStartTime = const TimeOfDay(hour: 8, minute: 30);
  final ScheduleController _scheduleController = Get.put(ScheduleController());
  int _selectedColor = 0;
  DateTime _selectedDate = DateTime.now();
  int _selectedRemind = 5;
  String _selectedRepeat = "Monday";
  TimeOfDay _selectedTime = const TimeOfDay(hour: 8, minute: 30);
  String _startTime = "8:30 AM";
  final TextEditingController _subjectController = TextEditingController();

  @override
  void initState() {
    NotificationService().init();
    super.initState();
  }

  _validate() {
    if (_subjectController.text.isNotEmpty &&
        _detaillController.text.isNotEmpty) {
      _addScheduleToDb();
      Get.back();
    } else if (_subjectController.text.isEmpty ||
        _detaillController.text.isEmpty) {
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
            children: List<Widget>.generate(6, (int index) {
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
        }))
      ],
    );
  }

  _addScheduleToDb() async {
    try {
      int id = await _scheduleController.addSchedule(
        schedule: Schedule(
          subject: _subjectController.text.toString(),
          detail: _detaillController.text.toString(),
          day: _selectedRepeat,
          startTime: _startTime,
          endTime: _endTime,
          color: _selectedColor,
          remind: _selectedRemind,
        ),
      );
      _scheduleController.getSchedule();
      _setNoltification(id);
      print("my id is $id");
    } catch (e) {
      print(e);
    }
  }

  _setNoltification(int id) async {
    DateTime time = DateFormat.jm().parse(_startTime.toString());
    await NotificationService().zonedScheduleNotification(
      title: _subjectController.text.toString(),
      body: _detaillController.text.toString(),
      id: id,
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
                "Add Schedule",
                style: headingStyle,
              ),
              const SizedBox(height: 10),
              InputField(
                title: 'Subject',
                hint: 'Enter your subject',
                controller: _subjectController,
              ),
              InputField(
                title: 'Detail',
                hint: 'Enter your detail',
                controller: _detaillController,
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Day",
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
                          items: dayList
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
              Row(
                children: [
                  Expanded(
                    child: InputField(
                      title: 'Start',
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
                      title: 'End',
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
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _colorPallete(),
                  MyButton(
                    label: "Add Schedule",
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
