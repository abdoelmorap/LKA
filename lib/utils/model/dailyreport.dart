class DailyReportModel {
  int id;
  int studentId;
  int morning;
  int noon;
  int afternoon;
  int breakfast;
  int lunch;
  int snack;
  int water;
  int milk;
  int juice;
  int hygiene;
  dynamic temperature;
  int sleep;
  String comment;
  String dateOfDay;
  String createdAt;
  String updatedAt;
  int admissionNo;
  String firstName;
  String lastName;
  String fullName;
  String dateOfBirth;
  String caste;
  String email;
  String mobile;
  String admissionDate;
  String studentPhoto;
  int age;
  String height;
  String weight;
  int activeStatus;
  int bloodgroupId;
  int religionId;
  int parentId;
  int userId;
  int roleId;
  int genderId;
  int schoolId;
  int academicId;

  DailyReportModel(
      {this.id,
      this.studentId,
      this.morning,
      this.noon,
      this.afternoon,
      this.breakfast,
      this.lunch,
      this.snack,
      this.water,
      this.milk,
      this.juice,
      this.hygiene,
      this.temperature,
      this.sleep,
      this.comment,
      this.dateOfDay,
      this.createdAt,
      this.updatedAt,
      this.admissionNo,
      this.firstName,
      this.lastName,
      this.fullName,
      this.dateOfBirth,
      this.caste,
      this.email,
      this.mobile,
      this.admissionDate,
      this.studentPhoto,
      this.age,
      this.height,
      this.weight,
      this.activeStatus,
      this.bloodgroupId,
      this.religionId,
      this.parentId,
      this.userId,
      this.roleId,
      this.genderId,
      this.schoolId,
      this.academicId});

  DailyReportModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    studentId = json['student_id'];
    morning = json['morning'];
    noon = json['noon'];
    afternoon = json['afternoon'];
    breakfast = json['Breakfast'];
    lunch = json['Lunch'];
    snack = json['Snack'];
    water = json['water'];
    milk = json['milk'];
    juice = json['juice'];
    hygiene = json['Hygiene'];
    temperature = json['Temperature'];
    sleep = json['Sleep'];
    comment = json['Comment'];
    dateOfDay = json['Date_of_Day'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    admissionNo = json['admission_no'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    fullName = json['full_name'];
    dateOfBirth = json['date_of_birth'];
    caste = json['caste'];
    email = json['email'];
    mobile = json['mobile'];
    admissionDate = json['admission_date'];
    studentPhoto = json['student_photo'];
    age = json['age'];
    height = json['height'];
    weight = json['weight'];
    activeStatus = json['active_status'];
    bloodgroupId = json['bloodgroup_id'];
    religionId = json['religion_id'];
    parentId = json['parent_id'];
    userId = json['user_id'];
    roleId = json['role_id'];
    genderId = json['gender_id'];
    schoolId = json['school_id'];
    academicId = json['academic_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['student_id'] = this.studentId;
    data['morning'] = this.morning;
    data['noon'] = this.noon;
    data['afternoon'] = this.afternoon;
    data['Breakfast'] = this.breakfast;
    data['Lunch'] = this.lunch;
    data['Snack'] = this.snack;
    data['water'] = this.water;
    data['milk'] = this.milk;
    data['juice'] = this.juice;
    data['Hygiene'] = this.hygiene;
    data['Temperature'] = this.temperature;
    data['Sleep'] = this.sleep;
    data['Comment'] = this.comment;
    data['Date_of_Day'] = this.dateOfDay;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['admission_no'] = this.admissionNo;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['full_name'] = this.fullName;
    data['date_of_birth'] = this.dateOfBirth;
    data['caste'] = this.caste;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['admission_date'] = this.admissionDate;
    data['student_photo'] = this.studentPhoto;
    data['age'] = this.age;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['active_status'] = this.activeStatus;
    data['bloodgroup_id'] = this.bloodgroupId;
    data['religion_id'] = this.religionId;
    data['parent_id'] = this.parentId;
    data['user_id'] = this.userId;
    data['role_id'] = this.roleId;
    data['gender_id'] = this.genderId;
    data['school_id'] = this.schoolId;
    data['academic_id'] = this.academicId;
    return data;
  }
}
