import 'dart:ui';

import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:my_todo_list/controllers/task_controller.dart';
import 'package:my_todo_list/models/task_model.dart';
import 'package:my_todo_list/services/notification_services.dart';
import 'package:my_todo_list/services/theme_services.dart';
import 'package:my_todo_list/ui/add_task_page.dart';
import 'package:my_todo_list/ui/detail_page.dart';
import 'package:my_todo_list/ui/theme.dart';
import 'package:my_todo_list/ui/widgets/button.dart';
import 'package:my_todo_list/ui/widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  final _taskController = Get.put(TaskController());
  late NotifyHelper notifyHelper;
  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.requestIOSPermissions();
    notifyHelper.initializeNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _addDateBar(),
          _showTasks(),
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (BuildContext context, int index) {
            TaskModel task = _taskController.taskList[index];
            DateTime date = DateFormat.jm().parse(task.startTime!);
            String myTime = DateFormat("HH:mm").format(date);
            notifyHelper.scheduledNotification(
              int.parse(myTime.split(":")[0]),
              int.parse(myTime.split(":")[1]),
              task,
            );
            if (task.repeat == 'Daily') {
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => DetailPage(taskModel: task));
                          },
                          onLongPress: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  )));
            } else if (task.date == DateFormat.yMd().format(_selectedDate)) {
              DateTime date = DateFormat.jm().parse(task.startTime!);
              String myTime = DateFormat("HH:mm").format(date);
              notifyHelper.scheduledNotification(
                int.parse(myTime.split(":")[0]),
                int.parse(myTime.split(":")[1]),
                task,
              );
              return AnimationConfiguration.staggeredList(
                  position: index,
                  child: SlideAnimation(
                      child: FadeInAnimation(
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.to(() => DetailPage(taskModel: task));
                          },
                          onLongPress: () {
                            _showBottomSheet(context, task);
                          },
                          child: TaskTile(task),
                        )
                      ],
                    ),
                  )));
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  _showBottomSheet(BuildContext context, TaskModel task) {
    Get.bottomSheet(Container(
      padding: const EdgeInsets.only(top: 4),
      height: task.isCompleted == 1
          ? MediaQuery.of(context).size.height * .24
          : MediaQuery.of(context).size.height * .32,
      color: ThemeServices().isDarkTheme ? darkGreyClr : white,
      child: Column(
        children: [
          Container(
            height: 6,
            width: 120,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: ThemeServices().isDarkTheme
                    ? Colors.grey[600]
                    : Colors.grey[300]),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                task.isCompleted == 0
                    ? _bottomSheetButton(
                        context: context,
                        label: "Task Completed",
                        onTap: () {
                          _taskController.markTaskCompleted(task.id!);

                          Get.back();
                        },
                        color: primaryClr)
                    : Container(),
                _bottomSheetButton(
                    context: context,
                    label: "Delete Task",
                    onTap: () {
                      _taskController.delete(task);

                      Get.back();
                    },
                    color: Color.fromARGB(255, 226, 68, 56))
              ],
            ),
          ),
          _bottomSheetButton(
              isClose: true,
              context: context,
              label: 'Close',
              onTap: () => Get.back(),
              color: Colors.grey),
          SizedBox(
            height: 15,
          )
        ],
      ),
    ));
  }

  _bottomSheetButton({
    required BuildContext context,
    required String label,
    required VoidCallback onTap,
    required Color color,
    bool isClose = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width * .9,
        decoration: BoxDecoration(
          border: isClose
              ? Border.all(color: Color.fromARGB(255, 203, 203, 203))
              : Border.all(width: 0, color: color),
          color: isClose ? Colors.grey[200] : color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: isClose ? Colors.black87 : white,
              fontSize: 18,
              fontWeight: FontWeight.w500),
        ),
      ),
    );
  }

  Container _addDateBar() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: white,
        dateTextStyle: GoogleFonts.lato(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        dayTextStyle: GoogleFonts.lato(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        monthTextStyle: GoogleFonts.lato(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.grey,
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  Container _addTaskBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text(
                'Today',
                style: headingStyle,
              )
            ],
          ),
          MyButton(
              label: "+ Add Task",
              onTap: () {
                Get.to(() => AddTaskPage());
              })
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "MyTodoList",
        style: TextStyle(
            color: ThemeServices().isDarkTheme ? white : white, 
            fontWeight: FontWeight.bold),
      ),
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          notifyHelper.displayNotification(
              title: "Theme Changed",
              body: !Get.isDarkMode
                  ? "Activated Dark Theme"
                  : "Activated Light Theme");
          // notifyHelper.scheduledNotification();
          setState(() {});
        },
        child: ThemeServices().isDarkTheme
            ? Icon(Icons.sunny)
            : Icon(
                Icons.nights_stay,
                color: Colors.black,
              ),
      ),
      actions: [
        CircleAvatar(
          maxRadius: 23,
          backgroundColor: white,
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
}
