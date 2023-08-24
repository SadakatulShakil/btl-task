import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'Api/api_service.dart';
import 'Screens/add_task_screen.dart';
import 'Screens/main_screen.dart';
import 'Screens/splash_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ByteTrek Task',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/main': (context) => MainScreen(),
        '/add_task': (context) => AddTaskScreen(),
      },
    );
  }
}
