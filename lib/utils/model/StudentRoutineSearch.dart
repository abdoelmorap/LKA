class StudentRoutineSearch{

  String period;
  String startTime;
  String endTime;
  String subject;
  String room;

  StudentRoutineSearch({this.period, this.startTime, this.endTime,
      this.subject, this.room});

  factory StudentRoutineSearch.fromJson(Map<String,dynamic> json){
    return StudentRoutineSearch(
      period: json['period'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      subject: json['subject_name'],
      room: json['room_no']
    );
  }
}

class RoutineSearchList{

  List<StudentRoutineSearch> searchs;

  RoutineSearchList(this.searchs);


  factory RoutineSearchList.fromJson(List<dynamic> json){

    List<StudentRoutineSearch> searchList = [];

    searchList = json.map((i) => StudentRoutineSearch.fromJson(i)).toList();

    return RoutineSearchList(searchList);
  }
}
