import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/Tasks.dart';

class TaskItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final Duration duration;
  final String id;
  final bool isSelected;

  TaskItemWidget(
      {this.title, this.duration, this.description, this.id, this.isSelected});

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
      padding: EdgeInsets.symmetric(
        horizontal: isSelected ? 8 : 10,
        vertical: isSelected ? 3 : 5,
      ),
      child: Dismissible(
        key: UniqueKey(),
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
          } else {
            return Future<bool>.value(true);
          }
        },
        onDismissed: (direction) {
          if (direction == DismissDirection.endToStart) {
            Provider.of<Tasks>(context, listen: false).removeTask(id);
          } else {
            Provider.of<Tasks>(context, listen: false).toggleSelect(id);
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text(
                isSelected
                    ? 'Deselected task : $title'
                    : 'Selected task : $title',
              ),
            ));
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            border: Border.all(
                width: isSelected ? 3 : 0,
                color: Theme.of(context).primaryColor),
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
              isSelected ? Icons.star_border : Icons.star,
              color: Theme.of(context).cardColor,
            ),
            Text(
              isSelected ? "Deselect " : " Select",
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
