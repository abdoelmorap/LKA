// Project imports:
import 'Schedule.dart';

class ScheduleList{

  final List<ClassRoutine> schedules;

  ScheduleList(this.schedules);


  factory ScheduleList.fromJson(List<dynamic> parsedJson) {

    List<ClassRoutine> routines = [];

    routines = parsedJson.map((i) => ClassRoutine.fromJson(i)).toList();

    return ScheduleList(routines);
  }

}
