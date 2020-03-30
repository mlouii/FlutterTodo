import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/http_exception.dart';

class TaskItem {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final Duration duration;

  TaskItem(
      {@required this.id,
      @required this.title,
      this.description,
      @required this.dateTime,
      this.duration});
}

class Tasks with ChangeNotifier {
  List<TaskItem> _tasks = [
    TaskItem(
      id: '1',
      title: 'Get out of Bed!',
      description: 'Wake the fuck up',
      dateTime: DateTime.now(),
      duration: Duration(hours: 20),
    ),
    TaskItem(
      id: '1',
      title: 'Brush your teeth',
      description: 'Dental health is important',
      dateTime: DateTime.now(),
      duration: Duration(hours: 2, minutes: 30),
    ),
  ];

  List<TaskItem> get tasks {
    return [..._tasks];
  }

  Future<void> addTask(String title, [String description, Duration duration]) {
    const url = 'https://fluttertest-17c07.firebaseio.com/tasks.json';
    final timeStamp = DateTime.now();
    return http
        .post(url,
            body: json.encode({
              'title': title,
              'description': description,
              'duration': duration.toString(),
              'dateTime': timeStamp.toIso8601String(),
            }))
        .then((response) {
      _tasks.add(TaskItem(
        id: json.decode(response.body)['name'],
        title: title,
        dateTime: timeStamp,
        description: description,
        duration: duration,
      ));
      notifyListeners();
    });
  }

  Future<void> removeTask(String id) {
    final url = 'https://fluttertest-17c07.firebaseio.com/tasks/$id.json';
    return http.delete(url).then((response) {
      if (response.statusCode >= 400) {
        throw HttpException('Could not delete task');
      } else {
        _tasks.removeAt(_tasks.indexWhere((task) => task.id == id));
        notifyListeners();
      }
    });
  }
}
