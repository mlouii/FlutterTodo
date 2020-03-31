import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_duration_picker/flutter_duration_picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/providers/Tasks.dart';

class NewItemScreen extends StatefulWidget {
  static const routeName = '/new-item';

  @override
  _NewItemScreenState createState() => _NewItemScreenState();
}

class _NewItemScreenState extends State<NewItemScreen> {
  GlobalKey<FormState> _form = GlobalKey<FormState>();
  final _titleFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  Duration _duration = Duration(minutes: 1);
  String _title = '';
  String _description = '';
  bool _isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _titleFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    _isLoading = true;
    final isValid = _form.currentState.validate();
    _form.currentState.save();
    if (isValid) {
      Provider.of<Tasks>(context, listen: false)
          .addTask(_title, false, _description, _duration)
          .catchError((error) {
        showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text(
              'Something went wrong',
            ),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      }).then((_) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
      ;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add new Task',
          style: Theme.of(context).textTheme.title,
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromRGBO(93, 115, 160, 0.56),
              const Color.fromRGBO(239, 117, 145, 0.49)
            ],
            tileMode: TileMode.repeated,
          ),
        ),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      Container(
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
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12, right: 12),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Task Title',
                                hintStyle: Theme.of(context).textTheme.subhead),
                            style: Theme.of(context).textTheme.subtitle,
                            textInputAction: TextInputAction.next,
                            validator: (value) {
                              if (value.isEmpty) {
                                return 'Please enter a value!';
                              }
                              return null;
                            },
                            focusNode: _titleFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            onSaved: (value) {
                              _title = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                hintText: 'Task Description',
                                hintStyle: Theme.of(context).textTheme.subhead),
                            maxLines: 4,
                            style: Theme.of(context).textTheme.subtitle,
                            keyboardType: TextInputType.multiline,
                            textInputAction: TextInputAction.none,
                            focusNode: _descriptionFocusNode,
                            onFieldSubmitted: (_) {
                              FocusScope.of(context)
                                  .requestFocus(_descriptionFocusNode);
                            },
                            onSaved: (value) {
                              _description = value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Estimated Time',
                        style: Theme.of(context).textTheme.subhead,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 120),
                        child: Column(
                          children: <Widget>[
                            DurationPicker(
                              duration: _duration,
                              onChange: (val) {
                                setState(() {
                                  _duration = val;
                                });
                              },
                              snapToMins: 5,
                            ),
                          ],
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    blurRadius: 2,
                                    spreadRadius: 2,
                                    offset: Offset(-0.5, 2))
                              ],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: FlatButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.add,
                                      color: Theme.of(context).cardColor,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text(
                                        "Add Task",
                                        style: Theme.of(context)
                                            .textTheme
                                            .title
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .cardColor),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                _saveForm();
                              },
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(width: 1),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: FlatButton(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.close,
                                      color: Theme.of(context).primaryColorDark,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 2),
                                      child: Text(
                                        "Cancel",
                                        style: Theme.of(context)
                                            .textTheme
                                            .title
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColorDark),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
