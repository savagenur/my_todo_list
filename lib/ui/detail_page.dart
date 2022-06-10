import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_list/controllers/task_controller.dart';
import 'package:my_todo_list/models/task_model.dart';
import 'package:my_todo_list/services/theme_services.dart';
import 'package:my_todo_list/ui/theme.dart';
import 'package:my_todo_list/ui/widgets/button.dart';
import 'package:my_todo_list/ui/widgets/expanded_text_field.dart';
import 'package:my_todo_list/ui/widgets/input_field.dart';

class DetailPage extends StatefulWidget {
  final TaskModel taskModel;
  const DetailPage({Key? key, required this.taskModel}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final TaskController _taskController = Get.put(TaskController());
  late TextEditingController _titleController;
  late TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now());
  String _endTime =
      DateFormat("hh:mm a").format(DateTime.now().add(Duration(hours: 12)));
  int _selectedRemind = 5;
  int _selectedColor = 0;
  List<int> remindList = [
    5,
    10,
    15,
    20,
  ];
  String _selectedRepeat = "None";
  List<String> repeatList = [
    "None",
    "Daily",
    "Weekly",
  ];
  @override
  void initState() {
    _titleController = TextEditingController(text: widget.taskModel.title);
    _noteController = TextEditingController(text: widget.taskModel.note);
    _selectedDate = DateFormat.yMd().parse(widget.taskModel.date!);
    _startTime = widget.taskModel.startTime!;
    _endTime = widget.taskModel.endTime!;
    _selectedRemind = widget.taskModel.remind!;
    _selectedRepeat = widget.taskModel.repeat!;
    _selectedColor = widget.taskModel.color!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Add Task",
                    style: headingStyle,
                  ),
                  ExpandedTextField(
                    title: "Title",
                    hintText: 'Enter title here',
                    controller: _titleController,
                  ),
                  ExpandedTextField(
                      title: "Note",
                      hintText: 'Enter note here',
                      controller: _noteController),
                  MyInputField(
                    title: "Date",
                    hintText: DateFormat.yMd().format(_selectedDate),
                    widget: IconButton(
                      splashRadius: 20,
                      onPressed: () {
                        _getDateFromUser();
                      },
                      icon: Icon(
                        Icons.calendar_month_outlined,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: MyInputField(
                        title: "Start Time",
                        hintText: _startTime,
                        widget: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                          ),
                        ),
                      )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: MyInputField(
                        title: "End Time",
                        hintText: _endTime,
                        widget: IconButton(
                          splashRadius: 20,
                          onPressed: () {
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: Icon(
                            Icons.access_time_rounded,
                          ),
                        ),
                      ))
                    ],
                  ),
                  MyInputField(
                    title: 'Remind',
                    hintText: '$_selectedRemind minutes early',
                    widget: DropdownButton(
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRemind = int.parse(value!);
                        });
                      },
                      underline: Container(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      items:
                          remindList.map<DropdownMenuItem<String>>((int value) {
                        return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                  MyInputField(
                    title: 'Repeat',
                    hintText: _selectedRepeat,
                    widget: DropdownButton(
                      onChanged: (String? value) {
                        setState(() {
                          _selectedRepeat = value!;
                        });
                      },
                      underline: Container(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                      ),
                      iconSize: 32,
                      elevation: 4,
                      style: subTitleStyle,
                      items: repeatList
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _colorPallette(),
                      MyButton(
                          label: 'Update Task',
                          onTap: () {
                            _validateDate();
                            _taskController.getTasks();
                          })
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column _colorPallette() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Color',
          style: titleStyle,
        ),
        Wrap(
          children: List<Widget>.generate(4, (index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = index;
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: CircleAvatar(
                  radius: 16,
                  backgroundColor: index == 0
                      ? Color.fromARGB(255, 144, 117, 76)
                      : index == 1? primaryClr
                      : index == 2
                          ? pinkClr
                          : yellowClr,
                  child: _selectedColor == index
                      ? Icon(
                          Icons.check,
                          color: Colors.white,
                        )
                      : Container(),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  _validateDate() {
    if (_titleController.text.isNotEmpty || _noteController.text.isNotEmpty) {
      _updateWholeTask();
      Get.back();
    } else if (_titleController.text.isEmpty || _noteController.text.isEmpty) {
      Get.snackbar('Required', "At least one field is required!",
          colorText: Colors.black,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: white,
          margin: EdgeInsets.only(bottom: 30),
          icon: Icon(
            Icons.warning_amber_rounded,
            color: Colors.red,
          ));
    }
  }

  _addTaskToDb() async {
    int value = await _taskController.addTask(
        task: TaskModel(
      repeat: _selectedRepeat,
      title: _titleController.text,
      note: _noteController.text,
      isCompleted: 0,
      date: DateFormat.yMd().format(_selectedDate),
      startTime: _startTime,
      endTime: _endTime,
      color: _selectedColor,
      remind: _selectedRemind,
    ));
  }

// _updateWholeTask(){
//   _taskController.updateWholeTask(id:widget.taskModel.id!,title: widget.taskModel.title!);
// }

  _updateWholeTask()  {
    TaskModel task = widget.taskModel;
    _taskController.updateWholeTask(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColor,
        id: task.id!);
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      actions: [
        CircleAvatar(
          backgroundColor: Colors.white,
          backgroundImage: AssetImage(
            'assets/images/profile.png',
          ),
        ),
        SizedBox(
          width: 20,
        )
      ],
    );
  }

  _getDateFromUser() async {
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2015),
        lastDate: DateTime.now().add(Duration(days: 2500)));

    if (_pickerDate != null) {
      setState(() {
        _selectedDate = _pickerDate;
      });
    } else {
    }
  }

  _getTimeFromUser({required bool isStartTime}) async {
    var pickedTime = await _showTimePicker(isStartTime);
    String _formatedTime =
        pickedTime?.format(context) ?? (isStartTime ? _startTime : _endTime);
    if (pickedTime == null) {
    } else if (isStartTime) {
      setState(() {
        _startTime = _formatedTime;
      });
    } else if (!isStartTime) {
      setState(() {
        _endTime = _formatedTime;
      });
    }
  }

  _showTimePicker(bool isStartTime) {
    return showTimePicker(
      initialEntryMode: TimePickerEntryMode.dial,
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(isStartTime
            ? DateFormat.Hm()
                .format(DateFormat("hh:mm a").parse(_startTime))
                .split(':')[0]
            : DateFormat.Hm()
                .format(DateFormat("hh:mm a").parse(_endTime))
                .split(':')[0]),
        minute: int.parse(isStartTime
            ? _startTime.split(':')[1].split(' ')[0]
            : _endTime.split(':')[1].split(' ')[0]),
      ),
    );
  }
}
