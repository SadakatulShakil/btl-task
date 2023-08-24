class ApiTask {
  final int userId;
  final int id;
  final String title;
  final bool completed;

  ApiTask({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  factory ApiTask.fromJson(Map<String, dynamic> json) {
    return ApiTask(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      completed: json['completed'],
    );
  }
}
