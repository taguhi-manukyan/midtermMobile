import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NoteProvider(),
      child: const MyApp(),
    ),
  );
}

class Note {
  String content;
  Note(this.content);
}

class NoteProvider extends ChangeNotifier {
  final List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(String content) {
    if (content.trim().isNotEmpty) {
      _notes.insert(0, Note(content));
      notifyListeners();
    }
  }

  void updateNote(int index, String newContent) {
    if (newContent.trim().isNotEmpty && index >= 0 && index < _notes.length) {
      _notes[index].content = newContent;
      notifyListeners();
    }
  }
}


final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NotesListPage(),
    ),
    GoRoute(
      path: '/create',
      builder: (context, state) => const CreateNotePage(),
    ),
    GoRoute(
      path: '/edit/:index',
      builder: (context, state) {
        final index = int.tryParse(state.pathParameters['index'] ?? '-1') ?? -1;
        return CreateNotePage(editIndex: index);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routerConfig: _router,
    );
  }
}

class NotesListPage extends StatelessWidget {
  const NotesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final notes = context.watch<NoteProvider>().notes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('No notes yet. Tap + to add one!'))
          : ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) => ListTile(
          leading: const Icon(Icons.note),
          title: Text(notes[index].content),
          onTap: () {
            context.push('/edit/$index');
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/create'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class CreateNotePage extends StatefulWidget {
  final int? editIndex;

  const CreateNotePage({super.key, this.editIndex});

  @override
  State<CreateNotePage> createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.editIndex != null) {
      final notes = context.read<NoteProvider>().notes;
      if (widget.editIndex! >= 0 && widget.editIndex! < notes.length) {
        _controller.text = notes[widget.editIndex!].content;
      }
    }
  }

  void _saveNote() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final provider = context.read<NoteProvider>();

    if (widget.editIndex != null) {
      provider.updateNote(widget.editIndex!, text);
    } else {
      provider.addNote(text);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.editIndex != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                hintText: 'Write your note here...',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _saveNote,
              icon: const Icon(Icons.save),
              label: Text(isEditing ? 'Update Note' : 'Save Note'),
            ),
          ],
        ),
      ),
    );
  }
}