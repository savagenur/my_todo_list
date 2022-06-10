import 'package:flutter/material.dart';
import 'package:my_todo_list/services/theme_services.dart';
import 'package:my_todo_list/ui/theme.dart';

class NotifiedPage extends StatelessWidget {
  final String label;
  const NotifiedPage({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(label.split("|")[0]),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20),
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Color.fromARGB(255, 104, 110, 104)),
                color: ThemeServices().isDarkTheme
                    ? Color.fromARGB(255, 79, 84, 79)
                    : Color.fromARGB(255, 173, 235, 212),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Expanded(
                  child: Text(
                    label.split('|')[1],
                    style: headingStyle.copyWith(fontSize: 20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
