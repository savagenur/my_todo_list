import 'dart:convert';

class TaskModel {
  int? id;
  String? title;
  String? note;
  int? isCompleted;
  String? date;
  String? startTime;
  String? endTime;
  int? color;
  int? remind;
  String? repeat;
  TaskModel({this.repeat,  this.title, this.note, this.isCompleted,
      this.date, this.startTime, this.endTime, this.color, this.remind});

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};
  
    
    if(title != null){
      result.addAll({'title': title});
    }
    if(note != null){
      result.addAll({'note': note});
    }
    if(isCompleted != null){
      result.addAll({'isCompleted': isCompleted});
    }
    if(date != null){
      result.addAll({'date': date});
    }
    if(startTime != null){
      result.addAll({'startTime': startTime});
    }
    if(endTime != null){
      result.addAll({'endTime': endTime});
    }
    if(color != null){
      result.addAll({'color': color});
    }
    if(remind != null){
      result.addAll({'remind': remind});
    }
    if(repeat != null){
      result.addAll({'repeat': repeat});
    }
  
    return result;
  }

   TaskModel.fromMap(Map<String, dynamic> map) {
    
     id = map['id'];
     note = map['note'];
     title = map['title'].toString();
     isCompleted = map['isCompleted'];
     date = map['date'];
     startTime = map['startTime'];
     endTime = map['endTime'];
     color = map['color']?.toInt();
     remind = map['remind']?.toInt();
     repeat = map['repeat'];
    
  }

  Map<String, dynamic> toJson() => toMap();

  factory TaskModel.fromJson(Map<String, dynamic> map) => TaskModel.fromMap(map);
}
