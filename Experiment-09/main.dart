
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const CampusEventHubApp());
}

class CampusEventHubApp extends StatelessWidget {
  const CampusEventHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Campus Event Hub',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
        ),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _addEvent(BuildContext context) async {
    try {
      await FirestoreService().addEvent(
        title: 'Campus Hackathon 2026',
        category: 'Technical',
        venue: 'Main Auditorium',
        availableSeats: 50,
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Event added successfully'),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Future<void> _editEvent(
    BuildContext context,
    String id,
    String oldTitle,
  ) async {
    final controller = TextEditingController(
      text: oldTitle,
    );

    final title = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Event'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Event name',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(
                context,
                controller.text.trim(),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );

    controller.dispose();

    if (title != null && title.isNotEmpty) {
      try {
        await FirestoreService().updateEvent(id, title);
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = FirestoreService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Event Hub'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<
          QuerySnapshot<Map<String, dynamic>>>(
        stream: service.getEvents(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Unable to load events.'),
            );
          }

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final events = snapshot.data?.docs ?? [];

          if (events.isEmpty) {
            return const Center(
              child: Text(
                'No events yet. Add your first event!',
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              final data = event.data();

              return Card(
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.event),
                  ),
                  title: Text(
                    data['title'] ?? 'Untitled Event',
                  ),
                  subtitle: Text(
                    '${data['category'] ?? 'General'} • '
                    '${data['venue'] ?? 'Venue not specified'}\n'
                    'Available seats: '
                    '${data['availableSeats'] ?? 0}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) async {
                      if (value == 'edit') {
                        await _editEvent(
                          context,
                          event.id,
                          data['title'] ?? '',
                        );
                      } else if (value == 'delete') {
                        try {
                          await service.deleteEvent(
                            event.id,
                          );
                        } catch (e) {
                          if (context.mounted) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              SnackBar(
                                content: Text('Error: $e'),
                              ),
                            );
                          }
                        }
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit'),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addEvent(context),
        icon: const Icon(Icons.add),
        label: const Text('Add Event'),
      ),
    );
  }
}

class FirestoreService {
  final CollectionReference<Map<String, dynamic>> events =
      FirebaseFirestore.instance.collection('events');

  Future<void> addEvent({
    required String title,
    required String category,
    required String venue,
    required int availableSeats,
  }) async {
    await events.add({
      'title': title,
      'category': category,
      'venue': venue,
      'availableSeats': availableSeats,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getEvents() {
    return events.snapshots();
  }

  Future<void> updateEvent(
    String id,
    String title,
  ) async {
    await events.doc(id).update({
      'title': title,
    });
  }

  Future<void> deleteEvent(String id) async {
    await events.doc(id).delete();
  }
}
