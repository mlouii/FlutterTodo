import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/models/http_exception.dart';

class TaskItem {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final Duration duration;
  bool isSelected;

  TaskItem(
      {@required this.id,
      @required this.title,
      this.description,
      @required this.dateTime,
      this.duration,
      this.isSelected = false});
}

class Tasks with ChangeNotifier {
  List<TaskItem> _tasks = [
    TaskItem(
      id: '1',
      title: 'Get out of Bed!',
      description: 'Wake the fuck up',
      dateTime: DateTime.now(),
      duration: Duration(hours: 20),
      isSelected: false,
    ),
    TaskItem(
      id: '1',
      title: 'Brush your teeth',
      description: 'Dental health is important',
      dateTime: DateTime.now(),
      duration: Duration(hours: 2, minutes: 30),
      isSelected: false,
    ),
  ];

  List<TaskItem> get tasks {
    return [..._tasks];
  }

  List<TaskItem> get selectedTasks {
    return _tasks.where((task) => task.isSelected).toList();
  }

  List<TaskItem> get nonSelectedTasks {
    return _tasks.where((task) => !task.isSelected).toList();
  }

  void toggleSelect(String id) {
    _tasks.firstWhere((task) => task.id == id).isSelected =
        !_tasks.firstWhere((task) => task.id == id).isSelected;
    notifyListeners();
    bool isFavorite = _tasks.firstWhere((task) => task.id == id).isSelected;
    print(id);
    final url = 'https://fluttertest-17c07.firebaseio.com/tasks/$id.json';
    http
        .patch(url,
            body: json.encode({
              'isSelected': isFavorite,
            }))
        .catchError((error) {
      print(error.toString());
    });
  }

  Future<void> addTask(String title, bool isSelected,
      [String description, Duration duration]) {
    const url = 'https://fluttertest-17c07.firebaseio.com/tasks.json';
    final timeStamp = DateTime.now();
    return http
        .post(url,
            body: json.encode({
              'title': title,
              'description': description,
              'duration': duration.toString(),
              'dateTime': timeStamp.toIso8601String(),
              'isSelected': isSelected,
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
