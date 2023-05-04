import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'add_device_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Smart Home'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('rooms').snapshots(),
        builder: (context, roomsSnapshot) {
          if (roomsSnapshot.hasData) {
            return ListView.builder(
              itemCount: roomsSnapshot.data!.docs.length,
              itemBuilder: (context, roomIndex) {
                var room = roomsSnapshot.data!.docs[roomIndex];

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('devices')
                      .where('room', isEqualTo: room['name'])
                      .snapshots(),
                  builder: (context, devicesSnapshot) {
                    if (devicesSnapshot.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              room['name'],
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding( // Added padding to the GridView.builder
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: GridView.builder(
                              itemCount: devicesSnapshot.data!.docs.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1.5, // Adjust the button aspect ratio
                              ),
                              itemBuilder: (context, deviceIndex) {
                                var device = devicesSnapshot.data!.docs[deviceIndex];
                                return ElevatedButton(
                                  onPressed: () {
                                    // Add future functionality here
                                  },
                                  child: Text(device['name']),
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    primary: Colors.blue,
                                    onPrimary: Colors.white,
                                    minimumSize: Size(100, 50), // Adjust the button minimum size
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                );
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddDevicePage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
