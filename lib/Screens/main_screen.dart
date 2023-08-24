import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math'; // Import the math package for random number generation
import '../Api/api_service.dart';
import '../Models/task.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<Task>> tasks;
  final ApiService _apiService = ApiService();
  bool showCompletedTasks = true;

  @override
  void initState() {
    super.initState();
    tasks = _apiService.getTasks();
  }

  Future<void> _fetchTasks() async {
    if (showCompletedTasks) {
      tasks = _apiService.getCompletedTasks();
    } else {
      tasks = _apiService.getIncompleteTasks();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'completed') {
                setState(() {
                  showCompletedTasks = true;
                  _fetchTasks();
                });
              } else if (value == 'incomplete') {
                setState(() {
                  showCompletedTasks = false;
                  _fetchTasks();
                });
              } else if (value == 'reset') {
                setState(() {
                  showCompletedTasks = true;
                  tasks = _apiService.getTasks(); // Reset the task list
                });
              } else if (value == 'more') {
                setState(() {
                  _showThankYouDialog(context);
                });
              }
            },
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: 'completed',
                  child: Text('Completed'),
                ),
                PopupMenuItem(
                  value: 'incomplete',
                  child: Text('Incomplete'),
                ),
                PopupMenuItem(
                  value: 'reset',
                  child: Text('Reset'),
                ),
                PopupMenuItem(
                  value: 'more',
                  child: Text('More'),
                ),
              ];
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Task>>(
        future: tasks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final taskList = snapshot.data!
                .where((task) => showCompletedTasks ? true : !task.completed)
                .toList();
            return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, index) {
                final task = taskList[index];

                // Generate a random color with reduced opacity
                final random = Random();
                final color = Colors.primaries[random.nextInt(Colors.primaries.length)].withOpacity(0.3);

                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  color: color,
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(task.title, style: GoogleFonts.ptSerif(fontSize: 18)),
                    trailing: Checkbox(
                      value: task.completed,
                      onChanged: (value) async {
                        setState(() {
                          task.completed = value!;
                        });
                        await _apiService.updateTask(task);
                      },
                    ),
                  ),
                );
              },
            );


          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTaskTitle = await Navigator.pushNamed(context, '/add_task');
          if (newTaskTitle != null) {
            await _apiService.addTask(newTaskTitle.toString());
            setState(() {
              tasks = _apiService.getTasks();
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showThankYouDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Thank You!'),
          content: Text('Thank you for reviewing my work.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Welcome'),
            ),
          ],
        );
      },
    );
  }
}
