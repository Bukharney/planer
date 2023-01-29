// ignore_for_file: constant_identifier_names

const String tableTasks = 'tasks';
const String tableSchedule = 'schedule';

class TaskFields {
  static const String COLOR = 'color';
  static const String DATE = 'date';
  static const String END_TIME = 'endTime';
  static const String ID = '_id';
  static const String IS_COMPLETED = 'isCompleted';
  static const String NOTE = 'note';
  static const String REMIND = 'remind';
  static const String REPEAT = 'repeat';
  static const String START_TIME = 'startTime';
  static const String TITLE = 'title';
  static final List<String> values = [
    ID,
    TITLE,
    NOTE,
    IS_COMPLETED,
    DATE,
    START_TIME,
    END_TIME,
    COLOR,
    REMIND,
    REPEAT,
  ];
}

class Task {
  Task({
    this.id,
    this.title,
    this.note,
    this.isCompleted,
    this.date,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
    this.repeat,
  });

  int? color;
  String? date;
  String? endTime;
  int? id;
  int? isCompleted;
  String? note;
  int? remind;
  String? repeat;
  String? startTime;
  String? title;

  static Task fromJson(Map<String, Object?> json) => Task(
        id: json[TaskFields.ID] as int?,
        title: json[TaskFields.TITLE] as String?,
        note: json[TaskFields.NOTE] as String?,
        isCompleted: json[TaskFields.IS_COMPLETED] as int?,
        date: json[TaskFields.DATE] as String?,
        startTime: json[TaskFields.START_TIME] as String?,
        endTime: json[TaskFields.END_TIME] as String?,
        color: json[TaskFields.COLOR] as int?,
        remind: json[TaskFields.REMIND] as int?,
        repeat: json[TaskFields.REPEAT] as String?,
      );

  Map<String, dynamic> toJson() => {
        TaskFields.ID: id,
        TaskFields.TITLE: title,
        TaskFields.NOTE: note,
        TaskFields.DATE: date,
        TaskFields.START_TIME: startTime,
        TaskFields.END_TIME: endTime,
        TaskFields.COLOR: color,
        TaskFields.REMIND: remind,
        TaskFields.REPEAT: repeat,
        TaskFields.IS_COMPLETED: isCompleted,
      };

  Task copy({
    int? id,
    String? title,
    String? note,
    int? isCompleted,
    String? date,
    String? startTime,
    String? endTime,
    int? color,
    int? remind,
    String? repeat,
  }) =>
      Task(
        id: id ?? this.id,
        title: title ?? this.title,
        note: note ?? this.note,
        isCompleted: isCompleted ?? this.isCompleted,
        date: date ?? this.date,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        color: color ?? this.color,
        remind: remind ?? this.remind,
        repeat: repeat ?? this.repeat,
      );
}

class ScheduleFields {
  static const String COLOR = 'color';
  static const String DAY = 'day';
  static const String DETAIL = 'detail';
  static const String END_TIME = 'endTime';
  static const String ID = '_id';
  static const String IS_COMPLETED = 'isCompleted';
  static const String REMIND = 'remind';
  static const String START_TIME = 'startTime';
  static const String SUBJECT = 'subject';
  static final List<String> values = [
    ID,
    SUBJECT,
    DETAIL,
    IS_COMPLETED,
    DAY,
    START_TIME,
    END_TIME,
    COLOR,
    REMIND,
  ];
}

class Schedule {
  Schedule({
    this.id,
    this.subject,
    this.detail,
    this.isCompleted,
    this.day,
    this.startTime,
    this.endTime,
    this.color,
    this.remind,
  });

  int? color;
  String? day;
  String? detail;
  String? endTime;
  int? id;
  int? isCompleted;
  int? remind;
  String? startTime;
  String? subject;

  static Schedule fromJson(Map<String, Object?> json) => Schedule(
        id: json[ScheduleFields.ID] as int?,
        subject: json[ScheduleFields.SUBJECT] as String?,
        detail: json[ScheduleFields.DETAIL] as String?,
        isCompleted: json[ScheduleFields.IS_COMPLETED] as int?,
        day: json[ScheduleFields.DAY] as String?,
        startTime: json[ScheduleFields.START_TIME] as String?,
        endTime: json[ScheduleFields.END_TIME] as String?,
        color: json[ScheduleFields.COLOR] as int?,
        remind: json[ScheduleFields.REMIND] as int?,
      );

  Map<String, Object?> toJson() => {
        ScheduleFields.ID: id,
        ScheduleFields.SUBJECT: subject,
        ScheduleFields.DETAIL: detail,
        ScheduleFields.DAY: day,
        ScheduleFields.START_TIME: startTime,
        ScheduleFields.END_TIME: endTime,
        ScheduleFields.COLOR: color,
        ScheduleFields.REMIND: remind,
      };

  Schedule copy({
    int? id,
    String? subject,
    String? detail,
    int? isCompleted,
    String? day,
    String? startTime,
    String? endTime,
    int? color,
    int? remind,
  }) =>
      Schedule(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        detail: detail ?? this.detail,
        isCompleted: isCompleted ?? this.isCompleted,
        day: day ?? this.day,
        startTime: startTime ?? this.startTime,
        endTime: endTime ?? this.endTime,
        color: color ?? this.color,
        remind: remind ?? this.remind,
      );
}
