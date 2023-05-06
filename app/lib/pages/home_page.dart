import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:app/pages/room_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _roomName = '';

  Future<void> _addRoom(String roomName) async {
    final roomExists = await FirebaseFirestore.instance
        .collection('rooms')
        .where('name', isEqualTo: roomName)
        .get();

    if (roomExists.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('rooms').add({
        'name': roomName,
        'created_at': DateTime.now().millisecondsSinceEpoch.toString(),
      
      });
    } else {
      throw Exception('Room already exists.');
    }
  }

  Future<void> _deleteRoom(String roomId) async {
    String roomName = (await FirebaseFirestore.instance.collection('rooms').doc(roomId).get())['name'];
    await RoomPage.deleteDevicesInRoom(roomName);
    await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();
  }
  Future<void> _showAddRoomDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Room'),
          content: Form(
            key: _formKey,
            child: TextFormField(
              decoration: const InputDecoration(labelText: 'Room Name'),
              onChanged: (value) {
                _roomName = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a room name';
                }
                return null;
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    await _addRoom(_roomName);
                    if (context.mounted) Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(e.toString()),
                      ),
                    );
                  }
                }
              },
              child: const Text('Add Room'),
            ),
          ],
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WELCOMETO SMART HOME', style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
        backgroundColor: Colors.transparent, // Ajout de cette ligne
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('rooms')
            .orderBy('created_at', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return GridView.count(
            crossAxisCount: 2,
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Material(
                  color: Theme.of(context).primaryColor,
                  borderRadius: BorderRadius.circular(8),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                            RoomPage(roomName: document['name']),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return SlideTransition(
                          position: Tween<Offset>(
                          begin: const Offset(1, 0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                    transitionDuration: const Duration(milliseconds: 200),
                  ),
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: const Text('Are you sure you want to delete this room?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _deleteRoom(document.id);
                                  if (context.mounted) Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container( // text in the button
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          document['name'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoomDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
