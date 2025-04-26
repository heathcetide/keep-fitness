class UserProfileForm {
  UserProfileForm();

  String? gender;
  int? age;
  double? heightCm;
  double? weightKg;

  // 健康信息
  String? medicalHistory;
  String? exerciseHabit;
  String? dietPreference;
  double? sleepHours;
  String? smokingHabit;

  // 目标信息
  double? targetWeight;
  int? goalDurationWeeks;
  int? dailyCalorieGoal;
  int? dailyStepsGoal;

  // 身体详细数据
  double? bodyFatPercent;
  double? muscleMass;
  double? bmr;
  double? bmi;
  double? waistCm;
  double? hipCm;

  Map<String, dynamic> toJson() {
    return {
      'gender': gender,
      'age': age,
      'heightCm': heightCm,
      'weightKg': weightKg,
      'medicalHistory': medicalHistory,
      'exerciseHabit': exerciseHabit,
      'dietPreference': dietPreference,
      'sleepHours': sleepHours,
      'smokingHabit': smokingHabit,
      'targetWeight': targetWeight,
      'goalDurationWeeks': goalDurationWeeks,
      'dailyCalorieGoal': dailyCalorieGoal,
      'dailyStepsGoal': dailyStepsGoal,
      'bodyFatPercent': bodyFatPercent,
      'muscleMass': muscleMass,
      'bmr': bmr,
      'bmi': bmi,
      'waistCm': waistCm,
      'hipCm': hipCm,
    };
  }

  factory UserProfileForm.fromJson(Map<String, dynamic> json) {
    return UserProfileForm()
      ..gender = json['gender']?.toString()
      ..age = _parseInt(json['age'])
      ..heightCm = _parseDouble(json['heightCm'])
      ..weightKg = _parseDouble(json['weightKg'])
      ..medicalHistory = json['medicalHistory']?.toString()
      ..exerciseHabit = json['exerciseHabit']?.toString()
      ..dietPreference = json['dietPreference']?.toString()
      ..sleepHours = _parseDouble(json['sleepHours'])
      ..smokingHabit = json['smokingHabit']?.toString()
      ..targetWeight = _parseDouble(json['targetWeight'])
      ..goalDurationWeeks = _parseInt(json['goalDurationWeeks'])
      ..dailyCalorieGoal = _parseInt(json['dailyCalorieGoal'])
      ..dailyStepsGoal = _parseInt(json['dailyStepsGoal'])
      ..bodyFatPercent = _parseDouble(json['bodyFatPercent'])
      ..muscleMass = _parseDouble(json['muscleMass'])
      ..bmr = _parseDouble(json['bmr'])
      ..bmi = _parseDouble(json['bmi'])
      ..waistCm = _parseDouble(json['waistCm'])
      ..hipCm = _parseDouble(json['hipCm']);
  }

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value.toString());
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString());
  }
}
