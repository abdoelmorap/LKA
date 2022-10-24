
class Timeline{

  String title;
  String date;
  String description;
  String file;


  Timeline({this.title, this.date, this.description,this.file});

  factory Timeline.fromJson(Map<String,dynamic> json){
    return Timeline(
      title: json['title'],
      date: json['date'],
      description: json['description'],
      file: json['file'],
    );
  }

}

class TimelineList{

  List<Timeline> timelines;

  TimelineList(this.timelines);

  factory TimelineList.fromJson(List<dynamic> json){

    List<Timeline> timelineList;

    timelineList = json.map((i)=>Timeline.fromJson(i)).toList();

    return TimelineList(timelineList);

  }

}
