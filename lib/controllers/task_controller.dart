import 'package:get/get.dart';
import 'package:my_todo_list/db/db_helper.dart';
import 'package:my_todo_list/models/task_model.dart';

class TaskController extends GetxController {
  var taskList = <TaskModel>[].obs;

  @override
  void onReady() {
    getTasks();
    super.onReady();
  }

  Future<int> addTask({TaskModel? task}) async {
    return await DBHelper.insert(task!);
  }

  void getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => TaskModel.fromJson(data)).toList());
  }

  void delete(TaskModel task) async {
    await DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
// void updateWholeTask({required int id, required String title}) async {
//     await DBHelper.updateWholeTask(id:id,title:title);
//     getTasks();
//   }

  void updateWholeTask({
    required String title,
    required String note,
    required String date,
    required String startTime,
    required String endTime,
    required int remind,
    required String repeat,
    required int color,
    required int id,
  }) async {
    await DBHelper.updateWholeTask(
      title: title,
      note: note,
      date: date,
      startTime: startTime,
      endTime: endTime,
      remind: remind,
      repeat: repeat,
      color: color,
      id: id,
    );
    getTasks();
    
  }
}
