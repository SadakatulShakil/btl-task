import 'dart:convert';
import 'package:http/http.dart' as http;

import '../Models/task.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  Future<List<Task>> getTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todos'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      throw Exception('Failed to load tasks');
    }
  }

  Future<Task> addTask(String title) async {
    final response = await http.post(
      Uri.parse('$baseUrl/todos'),
      body: json.encode({'title': title, 'completed': false}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 201) {
      final taskJson = json.decode(response.body);
      return Task.fromJson(taskJson);
    } else {
      throw Exception('Failed to add task');
    }
  }

  Future<void> updateTask(Task task) async {
    final response = await http.put(
      Uri.parse('$baseUrl/todos/${task.id}'),
      body: json.encode(task.toJson()),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update task');
    }
  }

  Future<List<Task>> getCompletedTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todos?completed=true'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      throw Exception('Failed to load completed tasks');
    }
  }

  Future<List<Task>> getIncompleteTasks() async {
    final response = await http.get(Uri.parse('$baseUrl/todos?completed=false'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((taskJson) => Task.fromJson(taskJson)).toList();
    } else {
      throw Exception('Failed to load incomplete tasks');
    }
  }
}
