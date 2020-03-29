import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/Tasks.dart';

class TaskItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final Duration duration;
  final String id;

  TaskItemWidget({this.title, this.duration, this.description, this.id});

  String formatDuration(Duration duration) {
    String toReturn = '';
    int hours = int.parse(duration.toString().split(':')[0]);
    int minutes = int.parse(duration.toString().split(':')[1]);
    if (hours > 0) {
      toReturn = "${hours}h";
    }
    if (minutes > 0) {
      toReturn = toReturn + " ${minutes}m";
    }
    return toReturn;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Dismissible(
        key: ValueKey(id),
        //direction: DismissDirection.endToStart,
        background: slideRightBackground(context),
        secondaryBackground: slideLeftBackground(context),
        // ignore: missing_return
        confirmDismiss: (direction) async {
          if (direction == DismissDirection.endToStart) {
            final bool res = await showDialog(
                context: context,
                builder: (BuildContext ctx) {
                  return AlertDialog(
                    title: Text('Are you sure?'),
                    content: Text('Remove task "$title"?'),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('No'),
                        onPressed: () {
                          Navigator.of(ctx).pop(false);
                        },
                      ),
                      FlatButton(
                        child: Text('Yes'),
                        onPressed: () {
                          Navigator.of(ctx).pop(true);
                        },
                      ),
                    ],
                  );
                });
            return res;
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            Provider.of<Tasks>(context, listen: false).removeTask(id);
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey,
                  blurRadius: 2,
                  spreadRadius: 2,
                  offset: Offset(-0.5, 2))
            ],
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: ListTile(
            title: Text(
              title,
              style: Theme.of(context).textTheme.title,
            ),
            subtitle: Text(
              description,
              style: Theme.of(context).textTheme.subtitle,
            ),
            trailing: Text(
              duration == null ? 'NA' : formatDuration(duration),
              style: Theme.of(context).textTheme.caption,
            ),
            leading: VerticalDivider(
              thickness: 10,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  Widget slideLeftBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).accentColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Theme.of(context).cardColor,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
        alignment: Alignment.centerRight,
      ),
    );
  }

  Widget slideRightBackground(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: Align(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.star,
              color: Theme.of(context).cardColor,
            ),
            Text(
              " Select",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
        alignment: Alignment.centerLeft,
      ),
    );
  }
}
