import 'package:flutter/material.dart';

void main() => runApp(const GreenTodoApp());

const Color leafGreen = Color(0xFF8BCF9B);
const Color deepGreen = Color(0xFF246B45);
const Color paleGreen = Color(0xFFEAF7ED);
const Color ink = Color(0xFF171C19);

class GreenTodoApp extends StatelessWidget {
  const GreenTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GreenTask',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF7FAF7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: deepGreen,
          primary: deepGreen,
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: ink,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F8F5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFE1EAE2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: deepGreen, width: 1.5),
          ),
        ),
      ),
      home: const LoginPage(),
    );
  }
}

class TodoTask {
  TodoTask({
    required this.title,
    required this.description,
    this.isDone = false,
    this.dueLabel = 'No deadline',
  });

  String title;
  String description;
  String dueLabel;
  bool isDone;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    // Demo login only: this checks the form, not a real email account.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => TodoHome(
          email: _emailController.text.trim(),
          displayName: _emailController.text.trim().split('@').first,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 88,
                      width: 88,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: paleGreen,
                        borderRadius: BorderRadius.circular(28),
                      ),
                      child: const Icon(Icons.task_alt_rounded,
                          color: deepGreen, size: 52),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'Welcome back',
                      style: TextStyle(
                        color: ink,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to organise your day, one task at a time.',
                      style: TextStyle(color: Colors.black54, fontSize: 15),
                    ),
                    const SizedBox(height: 32),
                    const Text('Email address',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: 'you@example.com',
                        prefixIcon: Icon(Icons.mail_outline_rounded),
                      ),
                      validator: (value) {
                        final email = value?.trim() ?? '';
                        if (email.isEmpty || !email.contains('@') ||
                            !email.contains('.')) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    const Text('Password',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _hidePassword,
                      decoration: InputDecoration(
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outline_rounded),
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePassword = !_hidePassword),
                          icon: Icon(_hidePassword
                              ? Icons.visibility_outlined
                              : Icons.visibility_off_outlined),
                        ),
                      ),
                      validator: (value) {
                        if ((value ?? '').length < 4) {
                          return 'Use at least 4 characters for this demo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 54,
                      child: FilledButton(
                        onPressed: _login,
                        style: FilledButton.styleFrom(
                          backgroundColor: deepGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                        ),
                        child: const Text('Login',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Demo login: enter any valid-looking email and a password with 4+ characters. This screen does not verify a real account.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TodoHome extends StatefulWidget {
  const TodoHome({
    super.key,
    required this.email,
    required this.displayName,
  });

  final String email;
  final String displayName;

  @override
  State<TodoHome> createState() => _TodoHomeState();
}

class _TodoHomeState extends State<TodoHome> {
  int _selectedTab = 0;
  late String _name;
  late String _email;
  String _photoUrl = '';
  String _filter = 'All';
  final TextEditingController _quickTaskController = TextEditingController();

  final List<TodoTask> _tasks = [
    TodoTask(title: 'Plan my day', description: 'Write down the top priorities'),
    TodoTask(title: 'Practise coding', description: 'Spend 30 minutes on Dart'),
    TodoTask(
      title: 'Review class notes',
      description: 'Revise today’s topics',
      isDone: true,
    ),
  ];

  int get _completed => _tasks.where((task) => task.isDone).length;
  int get _pending => _tasks.length - _completed;

  @override
  void initState() {
    super.initState();
    _email = widget.email;
    _name = widget.displayName.isEmpty ? 'User' : widget.displayName;
  }

  @override
  void dispose() {
    _quickTaskController.dispose();
    super.dispose();
  }

  // Adds a task directly from the always-visible task bar.
  void _addQuickTask() {
    final title = _quickTaskController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Type a task name first')),
      );
      return;
    }

    setState(() {
      _tasks.insert(0, TodoTask(title: title, description: ''));
      _filter = 'All';
      _quickTaskController.clear();
    });

    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task added successfully')),
    );
  }

  void _addTask() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Add a task',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                autofocus: true,
                decoration: const InputDecoration(
                  labelText: 'Task title',
                  prefixIcon: Icon(Icons.edit_note_rounded),
                ),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Enter a task title'
                        : null,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  prefixIcon: Icon(Icons.notes_rounded),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                _tasks.insert(
                  0,
                  TodoTask(
                    title: titleController.text.trim(),
                    description: descriptionController.text.trim(),
                  ),
                );
              });
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task added')),
              );
            },
            child: const Text('Add task'),
          ),
        ],
      ),
    );
  }

  void _editTask(int index) {
    final task = _tasks[index];
    final titleController = TextEditingController(text: task.title);
    final descriptionController =
        TextEditingController(text: task.description);
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit task'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task title'),
                validator: (value) =>
                    (value == null || value.trim().isEmpty)
                        ? 'Task title is required'
                        : null,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                task.title = titleController.text.trim();
                task.description = descriptionController.text.trim();
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _deleteTask(int index) {
    final removedTitle = _tasks[index].title;
    setState(() => _tasks.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('"$removedTitle" deleted'),
        action: SnackBarAction(
          label: 'UNDO',
          onPressed: () => setState(() {
            _tasks.insert(
              index.clamp(0, _tasks.length),
              TodoTask(title: removedTitle, description: ''),
            );
          }),
        ),
      ),
    );
  }

  void _editProfile() {
    final nameController = TextEditingController(text: _name);
    final emailController = TextEditingController(text: _email);
    final photoController = TextEditingController(text: _photoUrl);
    final formKey = GlobalKey<FormState>();

    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Edit profile'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Your name'),
                  validator: (value) =>
                      (value == null || value.trim().isEmpty)
                          ? 'Enter your name'
                          : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: (value) =>
                      (value == null || !value.contains('@'))
                          ? 'Enter a valid email'
                          : null,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: photoController,
                  keyboardType: TextInputType.url,
                  decoration: const InputDecoration(
                    labelText: 'Profile photo URL (optional)',
                    hintText: 'https://example.com/photo.jpg',
                    prefixIcon: Icon(Icons.image_outlined),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Use a direct image URL. Leave blank to use your initials.',
                  style: TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (!formKey.currentState!.validate()) return;
              setState(() {
                _name = nameController.text.trim();
                _email = emailController.text.trim();
                _photoUrl = photoController.text.trim();
              });
              Navigator.pop(dialogContext);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _logout() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _buildTasksPage(),
            _buildProfilePage(),
          ],
        ),
      ),
      // The quick-add task bar stays visible above the bottom navigation
      // whenever the Tasks tab is open.
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_selectedTab == 0)
            SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    top: BorderSide(color: Color(0xFFE6EEE7)),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _quickTaskController,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _addQuickTask(),
                        decoration: const InputDecoration(
                          hintText: 'Add a new task...',
                          prefixIcon: Icon(
                            Icons.edit_note_rounded,
                            color: deepGreen,
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 52,
                      width: 52,
                      child: FilledButton(
                        onPressed: _addQuickTask,
                        style: FilledButton.styleFrom(
                          backgroundColor: deepGreen,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Icon(Icons.add_rounded, size: 28),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          NavigationBar(
            selectedIndex: _selectedTab,
            onDestinationSelected: (index) =>
                setState(() => _selectedTab = index),
            backgroundColor: Colors.white,
            indicatorColor: paleGreen,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.checklist_outlined),
                selectedIcon: Icon(Icons.checklist_rounded),
                label: 'Tasks',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'Profile',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksPage() {
    final visibleTasks = _tasks.where((task) {
      if (_filter == 'Completed') return task.isDone;
      if (_filter == 'Pending') return !task.isDone;
      return true;
    }).toList();

    final progress = _tasks.isEmpty ? 0.0 : _completed / _tasks.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
          decoration: const BoxDecoration(
            color: paleGreen,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('GREENTASK',
                            style: TextStyle(
                              color: deepGreen,
                              letterSpacing: 2.2,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            )),
                        const SizedBox(height: 8),
                        Text('Hi, $_name 👋',
                            style: const TextStyle(
                              color: ink,
                              fontSize: 27,
                              fontWeight: FontWeight.w800,
                            )),
                        const SizedBox(height: 4),
                        const Text('Make today count.',
                            style: TextStyle(color: Colors.black54)),
                      ],
                    ),
                  ),
                  _Avatar(name: _name, photoUrl: _photoUrl, radius: 27),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  _statCard('Total', _tasks.length, Icons.list_alt_rounded),
                  const SizedBox(width: 10),
                  _statCard('Done', _completed, Icons.check_circle_outline),
                  const SizedBox(width: 10),
                  _statCard('Pending', _pending, Icons.timelapse_rounded),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  const Expanded(
                    child: Text('Daily progress',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                  Text('${(progress * 100).round()}%',
                      style: const TextStyle(
                          color: deepGreen, fontWeight: FontWeight.w800)),
                ],
              ),
              const SizedBox(height: 9),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Colors.white,
                  color: deepGreen,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
          child: Row(
            children: [
              const Expanded(
                child: Text('My tasks',
                    style: TextStyle(
                        fontSize: 22, fontWeight: FontWeight.w800, color: ink)),
              ),
              IconButton(
                tooltip: 'Add task with description',
                onPressed: _addTask,
                icon: const Icon(Icons.playlist_add_rounded, color: deepGreen),
              ),
              DropdownButton<String>(
                value: _filter,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(14),
                items: const ['All', 'Pending', 'Completed']
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) => setState(() => _filter = value ?? 'All'),
              ),
            ],
          ),
        ),
        Expanded(
          child: visibleTasks.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.task_alt_rounded,
                          size: 64, color: leafGreen),
                      const SizedBox(height: 10),
                      Text(
                        _filter == 'All'
                            ? 'No tasks yet'
                            : 'No ${_filter.toLowerCase()} tasks',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 4),
                      const Text('Use the add-task bar below to get started.'),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  itemCount: visibleTasks.length,
                  itemBuilder: (context, index) {
                    final task = visibleTasks[index];
                    final actualIndex = _tasks.indexOf(task);
                    return Card(
                      color: Colors.white,
                      elevation: 0,
                      margin: const EdgeInsets.only(bottom: 11),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFFE6EEE7)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 4, 8),
                        child: Row(
                          children: [
                            Checkbox(
                              value: task.isDone,
                              activeColor: deepGreen,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                              onChanged: (value) => setState(
                                  () => task.isDone = value ?? false),
                            ),
                            Expanded(
                              child: InkWell(
                                onTap: () => _editTask(actualIndex),
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        task.title,
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: task.isDone
                                              ? Colors.black45
                                              : ink,
                                          decoration: task.isDone
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none,
                                        ),
                                      ),
                                      if (task.description.isNotEmpty) ...[
                                        const SizedBox(height: 5),
                                        Text(
                                          task.description,
                                          style: TextStyle(
                                            color: task.isDone
                                                ? Colors.black38
                                                : Colors.black54,
                                            decoration: task.isDone
                                                ? TextDecoration.lineThrough
                                                : TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                      const SizedBox(height: 7),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 9, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: task.isDone
                                              ? paleGreen
                                              : const Color(0xFFF1F3F1),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Text(
                                          task.isDone ? 'COMPLETED' : 'PENDING',
                                          style: TextStyle(
                                            fontSize: 10,
                                            letterSpacing: .5,
                                            fontWeight: FontWeight.w800,
                                            color: task.isDone
                                                ? deepGreen
                                                : Colors.black54,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: (choice) {
                                if (choice == 'edit') _editTask(actualIndex);
                                if (choice == 'delete') _deleteTask(actualIndex);
                              },
                              itemBuilder: (_) => const [
                                PopupMenuItem(
                                  value: 'edit',
                                  child: ListTile(
                                    leading: Icon(Icons.edit_outlined),
                                    title: Text('Edit'),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 'delete',
                                  child: ListTile(
                                    leading: Icon(Icons.delete_outline,
                                        color: Colors.red),
                                    title: Text('Delete'),
                                    contentPadding: EdgeInsets.zero,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _statCard(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            Icon(icon, color: deepGreen, size: 21),
            const SizedBox(height: 6),
            Text('$count',
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(title,
                style: const TextStyle(fontSize: 11, color: Colors.black54)),
          ],
        ),
      ),
    );
  }

  Widget _buildProfilePage() {
    final progress = _tasks.isEmpty ? 0.0 : _completed / _tasks.length;
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text('My profile',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(22),
          decoration: BoxDecoration(
            color: paleGreen,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            children: [
              _Avatar(name: _name, photoUrl: _photoUrl, radius: 48),
              const SizedBox(height: 14),
              Text(_name,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.w800, color: ink)),
              const SizedBox(height: 5),
              Text(_email, style: const TextStyle(color: Colors.black54)),
              const SizedBox(height: 18),
              OutlinedButton.icon(
                onPressed: _editProfile,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit profile / photo'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: deepGreen,
                  side: const BorderSide(color: deepGreen),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        const Text('Your productivity',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 12),
        Row(
          children: [
            _profileStat('Completed', _completed, Icons.check_circle_rounded),
            const SizedBox(width: 12),
            _profileStat('Pending', _pending, Icons.pending_actions_rounded),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFFE6EEE7)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Completion rate',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 10),
              Text('${(progress * 100).round()}%',
                  style: const TextStyle(
                      fontSize: 30,
                      color: deepGreen,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                color: deepGreen,
                backgroundColor: paleGreen,
                borderRadius: BorderRadius.circular(20),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        OutlinedButton.icon(
          onPressed: _logout,
          icon: const Icon(Icons.logout_rounded),
          label: const Text('Log out'),
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.black87,
            minimumSize: const Size.fromHeight(52),
            side: const BorderSide(color: Color(0xFFD7E1D8)),
          ),
        ),
        const SizedBox(height: 12),
        const Center(
          child: Text(
            'GreenTask • Stay focused, grow every day',
            style: TextStyle(color: Colors.black45, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _profileStat(String title, int count, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE6EEE7)),
        ),
        child: Column(
          children: [
            Icon(icon, color: deepGreen, size: 28),
            const SizedBox(height: 8),
            Text('$count',
                style: const TextStyle(
                    fontSize: 26, fontWeight: FontWeight.w800)),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({
    required this.name,
    required this.photoUrl,
    required this.radius,
  });

  final String name;
  final String photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final hasPhoto = photoUrl.trim().startsWith('http');
    return CircleAvatar(
      radius: radius,
      backgroundColor: deepGreen,
      backgroundImage: hasPhoto ? NetworkImage(photoUrl.trim()) : null,
      onBackgroundImageError: hasPhoto ? (_, __) {} : null,
      child: hasPhoto
          ? null
          : Text(
              name.trim().isEmpty ? 'U' : name.trim()[0].toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: radius * .8,
                fontWeight: FontWeight.w800,
              ),
            ),
    );
  }
}
