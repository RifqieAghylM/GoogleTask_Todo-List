import 'package:flutter/material.dart';

void main() {
  runApp(const GoogleTasksApp());
}

class GoogleTasksApp extends StatelessWidget {
  const GoogleTasksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Google Tasks Clone',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A73E8),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: const TasksHomePage(),
    );
  }
}

class TaskItem {
  String title;
  bool isCompleted;

  TaskItem({required this.title, this.isCompleted = false});
}

class TasksHomePage extends StatefulWidget {
  const TasksHomePage({super.key});

  @override
  State<TasksHomePage> createState() => _TasksHomePageState();
}

class _TasksHomePageState extends State<TasksHomePage> {
  final List<TaskItem> _tasks = [];
  final TextEditingController _taskController = TextEditingController();

  void _showAddTaskBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _taskController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Tugas Baru',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 18),
                onSubmitted: (_) => _addTask(),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.sort, color: Colors.blueAccent),
                  TextButton(
                    onPressed: _addTask,
                    child: const Text(
                      'Simpan',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A73E8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _addTask() {
    if (_taskController.text.trim().isNotEmpty) {
      setState(() {
        _tasks.add(TaskItem(title: _taskController.text.trim()));
        _taskController.clear();
      });
      Navigator.pop(context);
    }
  }

  void _toggleTask(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeTaskCount = _tasks.where((task) => !task.isCompleted).length;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'Tasks',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 22,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Color(0xFF1A73E8),
              child: Text('R', style: TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FE),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Tugas Aktif: $activeTaskCount',
                style: const TextStyle(
                  color: Color(0xFF1A73E8),
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const Divider(height: 1),

          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_alt,
                          size: 80,
                          color: Colors.blue.shade100,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Semua tugas selesai',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Dismissible(
                        key: UniqueKey(),
                        background: Container(
                          color: Colors.red.shade100,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: const Icon(Icons.delete, color: Colors.red),
                        ),
                        onDismissed: (_) => _deleteTask(index),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 2,
                          ),
                          leading: Checkbox(
                            value: task.isCompleted,
                            shape: const CircleBorder(),
                            activeColor: const Color(0xFF1A73E8),
                            onChanged: (_) => _toggleTask(index),
                          ),
                          title: Text(
                            task.title,
                            style: TextStyle(
                              fontSize: 16,
                              color: task.isCompleted
                                  ? Colors.grey
                                  : Colors.black87,
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                            ),
                          ),
                          
                          trailing: IconButton(
                            icon: const Icon(
                              Icons.delete_outline,
                              color: Colors.grey,
                            ),
                            onPressed: () => _deleteTask(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTaskBottomSheet,
        backgroundColor: const Color(0xFFC2E7FF),
        elevation: 2,
        icon: const Icon(Icons.add, color: Color(0xFF001D35)),
        label: const Text(
          'Tambah tugas',
          style: TextStyle(
            color: Color(0xFF001D35),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}