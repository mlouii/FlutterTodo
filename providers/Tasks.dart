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
  List<TaskItem> _tasks = [];

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

  Duration _parseDuration(String s) {
    int hours = 0;
    int minutes = 0;
    int micros;
    List<String> parts = s.split(':');
    if (parts.length > 2) {
      hours = int.parse(parts[parts.length - 3]);
    }
    if (parts.length > 1) {
      minutes = int.parse(parts[parts.length - 2]);
    }
    micros = (double.parse(parts[parts.length - 1]) * 1000000).round();
    return Duration(hours: hours, minutes: minutes, microseconds: micros);
  }

  Future<void> fetchAndSetTasks() async {
    const url = 'https://fluttertest-17c07.firebaseio.com/tasks.json';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return null;
      }
      final List<TaskItem> loadedTasks = [];
      extractedData.forEach((taskId, taskData) {
        loadedTasks.add(TaskItem(
          id: taskId,
          title: taskData['title'],
          description: taskData['description'],
          duration: _parseDuration(taskData['duration']),
          dateTime: DateTime.parse(taskData['dateTime']),
          isSelected: taskData['isSelected'],
        ));
      });
      _tasks = loadedTasks;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
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
        isSelected: isSelected,
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
