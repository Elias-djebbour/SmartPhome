import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RoomPage extends StatefulWidget {
  final String roomName;
  const RoomPage({super.key, required this.roomName});

  @override
  RoomPageState createState() => RoomPageState();

  static Future<void> deleteDevicesInRoom(String roomName) async {
    final roomPageState = RoomPageState();
    final devices = await FirebaseFirestore.instance
        .collection('devices')
        .where('room', isEqualTo: roomName)
        .get();

    for (var device in devices.docs) {
      String deviceName = device['name'];
      String deviceType = device['type'];
      await roomPageState._updateDeviceRoom(deviceName, deviceType, 'delete');
    }
  }
}

class RoomPageState extends State<RoomPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _deviceName = '';
  String _deviceType = '';
  String _pinNumber = '';
  final TextEditingController _delayController = TextEditingController();
  ValueNotifier<bool> refreshSensorList = ValueNotifier<bool>(false);

  Future<void> _addDevice(String deviceName, String deviceType) async {
    // cant add device to room if device already exists in this room but can add device to another room ?
    final deviceExists = await FirebaseFirestore.instance
        .collection('devices')
        .where('name', isEqualTo: deviceName)
        .where('room', isEqualTo: widget.roomName)
        .get();

    if (deviceExists.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('devices').add({
        'type': deviceType,
        'name': deviceName,
        'room': widget.roomName,
        'pin': int.parse(_pinNumber),
      });
    } else {
      throw Exception('Device already exists.');
    }
  }

  Future<void> _updateDeviceRoom(
      String deviceName, String deviceType, String option) async {
    // Get the device with the given name.
    final deviceQuery = await FirebaseFirestore.instance
        .collection('devices')
        .where('name', isEqualTo: deviceName)
        .get();

    // If adding a new actuator device, add it directly and return
    if (option == 'add' && deviceType == 'actuator') {
      await _addDevice(deviceName, deviceType);
      return;
    }

    // Check if the device exists.
    if (deviceQuery.docs.isNotEmpty) {
      // Get the document ID of the device.
      String deviceId = deviceQuery.docs.first.id;

      if (option == 'delete') {
        if (deviceType == 'sensor') {
          await FirebaseFirestore.instance
              .collection('devices')
              .doc(deviceId)
              .update({'room': null, 'delay': null});
        } else if (deviceType == 'actuator') {
          await FirebaseFirestore.instance
              .collection('devices')
              .doc(deviceId)
              .delete();
        }
      } else if (option == 'add') {
        if (deviceType == 'sensor') {
          await FirebaseFirestore.instance
              .collection('devices')
              .doc(deviceId)
              .update({
            'room': widget.roomName,
            'delay': int.parse(_delayController.text)
          });
        }
      }
    } else {
      throw Exception('Device not found.');
    }
  }

  Future<void> _showAddDeviceDialog(BuildContext context) async {
    void resetForm() {
      _formKey.currentState!.reset();
      _deviceType = '';
      _deviceName = '';
      _pinNumber = '';
      _delayController.text = '';
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Add Device'),
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration:
                          const InputDecoration(labelText: 'Device Type'),
                      value: _deviceType.isEmpty ? null : _deviceType,
                      items: const [
                        DropdownMenuItem(
                            value: 'actuator', child: Text('Actuator')),
                        DropdownMenuItem(
                            value: 'sensor', child: Text('Sensor')),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _deviceType = value!;
                          if (_deviceType == 'sensor') {
                            _deviceName = '';
                            _delayController.text = '';
                            _pinNumber = '';
                          }
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a device type';
                        }
                        return null;
                      },
                    ),
                    if (_deviceType == 'actuator')
                      Column(
                        children: [
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Device Name'),
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
                          TextFormField(
                            decoration:
                                const InputDecoration(labelText: 'Pin Number'),
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              _pinNumber = value;
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter a pin number';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    if (_deviceType == 'sensor')
                      FutureBuilder<QuerySnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('devices')
                            .where('room', isNull: true)
                            .where('type', isEqualTo: 'sensor')
                            .get(),
                        builder: (BuildContext context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          return DropdownButtonFormField<String>(
                            decoration:
                                const InputDecoration(labelText: 'Sensor Name'),
                            value: _deviceName.isEmpty ? null : _deviceName,
                            items: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              String sensorName = document['name'];
                              return DropdownMenuItem(
                                  value: sensorName, child: Text(sensorName));
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _deviceName = value!;
                                _delayController.text = '';
                                _pinNumber = '';
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please select a sensor name';
                              }
                              return null;
                            },
                          );
                        },
                      ),
                    if (_deviceType == 'sensor' && _deviceName.isNotEmpty)
                      FutureBuilder<DocumentSnapshot>(
                        future: FirebaseFirestore.instance
                            .collection('devices')
                            .where('name', isEqualTo: _deviceName)
                            .get()
                            .then((querySnapshot) => querySnapshot.docs.first),
                        builder: (BuildContext context,
                            AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }

                          if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          }

                          Map<String, dynamic> sensorData =
                              snapshot.data!.data() as Map<String, dynamic>;

                          if (sensorData.containsKey('delay')) {
                            return TextFormField(
                              controller: _delayController,
                              decoration: const InputDecoration(
                                  labelText: 'Sensor Delay'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter a delay value';
                                }
                                return null;
                              },
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    resetForm();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      try {
                        await _updateDeviceRoom(
                            _deviceName, _deviceType, 'add');
                        resetForm();
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
                  child: const Text('Add Device'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.roomName} Devices'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('devices')
            .where('room', isEqualTo: widget.roomName)
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
                    // change to device page
                    onTap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) =>
                                  RoomPage(roomName: document['name']),
                          transitionsBuilder:
                              (context, animation, secondaryAnimation, child) {
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
                            content: const Text(
                                'Are you sure you want to delete this device?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await _updateDeviceRoom(
                                      _deviceName, _deviceType, 'delete');
                                  if (context.mounted) Navigator.pop(context);
                                },
                                child: const Text('Delete'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Container(
                      // text in the button
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
          _showAddDeviceDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
