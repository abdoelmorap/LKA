// To parse this JSON data, do
//
//     final lessonPlan = lessonPlanFromJson(jsonString);

import 'dart:convert';

LessonPlan lessonPlanFromJson(String str) => LessonPlan.fromJson(json.decode(str));

String lessonPlanToJson(LessonPlan data) => json.encode(data.toJson());

class LessonPlan {
    LessonPlan({
        this.thisWeek,
        this.weeks,
    });

    dynamic thisWeek;
    List<Week> weeks;

    factory LessonPlan.fromJson(Map<String, dynamic> json) => LessonPlan(
        thisWeek: json["this_week"],
        weeks: List<Week>.from(json["weeks"].map((x) => Week.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "this_week": thisWeek,
        "weeks": List<dynamic>.from(weeks.map((x) => x.toJson())),
    };
}

class Week {
    Week({
        this.id,
        this.name,
        this.isWeekend,
        this.date,
    });

    int id;
    String name;
    int isWeekend;
    String date;

    factory Week.fromJson(Map<String, dynamic> json) => Week(
        id: json["id"],
        name: json["name"],
        isWeekend: json["isWeekend"],
        date: json["date"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "isWeekend": isWeekend,
        "date": date,
    };
}
