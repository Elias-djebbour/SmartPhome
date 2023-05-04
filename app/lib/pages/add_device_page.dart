import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddDevicePage extends StatefulWidget {
  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _deviceName = '';
  String _roomName = '';
  List<String> _roomList = [];

  @override
  void initState() {
    super.initState();
    _loadRooms();
  }

  Future<void> _loadRooms() async {
    FirebaseFirestore.instance
        .collection('rooms')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        setState(() {
          _roomList.add(doc['name']);
        });
      });
    });
  }

  Future<void> _addRoom(String roomName) async {
    final roomExists = await FirebaseFirestore.instance
        .collection('rooms')
        .where('name', isEqualTo: roomName)
        .get();

    if (roomExists.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('rooms').add({'name': roomName});
    } else {
      throw Exception('Room already exists.');
    }
  }

  Future<void> _addDevice(String deviceName, String roomName) async {
    await FirebaseFirestore.instance
        .collection('devices')
        .add({'name': deviceName, 'room': roomName});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Device'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            TextFormField(
              decoration: InputDecoration(labelText: 'Device Name'),
              onChanged: (value) {
                _deviceName = value;
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a device name';
                }
                return null;
              },
            ),
            SizedBox(height: 16.0),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text == '') {
                  return const Iterable<String>.empty();
                }
                return _roomList.where((String room) {
                  return room.contains(textEditingValue.text);
                });
              },
              onSelected: (String selection) {
                setState(() {
                  _roomName = selection;
                });
              },
              fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                return TextFormField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: InputDecoration(labelText: 'Room Name'),
                  onChanged: (value) {
                    _roomName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter or select a room name';
                    }
                    return null;
                  },
                );
              },
            ),

            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  if (!_roomList.contains(_roomName)) {
                    try {
                      await _addRoom(_roomName);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(e.toString()),
                        ),
                      );
                      return;
                    }
                  }

                  try {
                    await _addDevice(_deviceName, _roomName);
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to add device.'),
                      ),
                );
              }
            }
          },
          child: Text('Add Device'),
        ),
      ],
    ),
  ),
);
}}