import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/Tasks.dart';
import 'package:todo_app/screens/tasks_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  MaterialColor createMaterialColor(Color color) {
    List strengths = <double>[.05];
    Map swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    strengths.forEach((strength) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    });
    return MaterialColor(color.value, swatch);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Tasks()),
      ],
      child: MaterialApp(
        title: 'Todo List',
        theme: ThemeData(
          primarySwatch:
              createMaterialColor(Color.fromRGBO(177, 139, 214, 1.0)),
          accentColor: createMaterialColor(Color.fromRGBO(239, 117, 145, 1.0)),
          cardColor: createMaterialColor(Color.fromRGBO(238, 229, 233, 1.0)),
          textTheme: TextTheme(
            title: TextStyle(fontFamily: 'Exo2', fontWeight: FontWeight.w600),
            subtitle: TextStyle(
                fontFamily: 'RobotoMono', fontWeight: FontWeight.w300),
            caption: TextStyle(fontFamily: 'Exo2', fontWeight: FontWeight.w600),
          ),
        ),
        home: TasksOverviewScreen(),
        routes: {
          TasksOverviewScreen.routeName: (ctx) => TasksOverviewScreen(),
        },
      ),
    );
  }
}
