import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TaskService {
  final CollectionReference taskCollection =
      FirebaseFirestore.instance.collection('tasks');

  Future<void> addTask(TaskModel task) async {
    await taskCollection.add(task.toMap());
  }

  Future<List<TaskModel>> getTasks() async {
    final snapshot = await taskCollection.orderBy('date').get();

    final today = DateTime.now();
    final todayOnly = DateTime(today.year, today.month, today.day);

    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final task = TaskModel.fromMap(data, doc.id);

      final taskDate = DateTime(
        task.date.year,
        task.date.month,
        task.date.day,
      );

      final isToday = taskDate == todayOnly;
      final show = isToday || !task.isDone;

      return show ? task : null;
    }).whereType<TaskModel>().toList();
  }

  Future<void> deleteTask(String id) async {
    await taskCollection.doc(id).delete();
  }

  Future<void> updateTask(TaskModel task) async {
    await taskCollection.doc(task.id).update(task.toMap());
  }
}
