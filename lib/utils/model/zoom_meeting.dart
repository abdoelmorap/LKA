class ZoomMeeting {
  final id;
  final meetingId;
  final password;
  final startDate;
  final startTime;
  DateTime endTime;
  final topic;
  final description;

  ZoomMeeting(
      {this.id,
      this.password,
      this.startTime,
      this.endTime,
      this.topic,
      this.description,
      this.meetingId,
      this.startDate});

  factory ZoomMeeting.fromJson(Map<String, dynamic> json) {
    return ZoomMeeting(
      id: json['id'],
      password: json['password'],
      meetingId: json['meeting_id'],
      startTime: json['time_of_meeting'],
      endTime: DateTime.parse(json["end_time"]),
      startDate: json['date_of_meeting'],
      description: json['description'],
      topic: json['topic'],
    );
  }
}

class ZoomMeetingList {
  final List<ZoomMeeting> meetings;

  ZoomMeetingList({this.meetings});

  factory ZoomMeetingList.fromJson(List<dynamic> json) {
    List<ZoomMeeting> meetingList = [];
    meetingList = json.map((e) => ZoomMeeting.fromJson(e)).toList();
    return ZoomMeetingList(meetings: meetingList);
  }
}
