abstract interface class Project {
  String get id;
  String get title;
  DateTime? get date;
  DateTime? get createdAt;
  bool get isCompleted;
}