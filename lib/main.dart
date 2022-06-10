import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:my_todo_list/db/db_helper.dart';
import 'package:my_todo_list/services/theme_services.dart';
import 'package:my_todo_list/ui/home_page.dart';
import 'package:my_todo_list/ui/theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBHelper.initDb();
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MyTodoList',
      themeMode: ThemeServices().theme,
      theme: Themes.light
          .copyWith(iconTheme: IconThemeData(color: Colors.black54)),
      darkTheme: Themes.dark
          .copyWith(iconTheme: IconThemeData(color: Colors.grey[400])),
      home: HomePage(),
    );
  }
}
