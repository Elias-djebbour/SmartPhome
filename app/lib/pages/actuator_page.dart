import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ActuatorPage extends StatefulWidget {
  final String deviceName;

  const ActuatorPage({Key? key, required this.deviceName}) : super(key: key);

  @override
  State<ActuatorPage> createState() => _ActuatorPageState();
}

class _ActuatorPageState extends State<ActuatorPage> {
  int actuatorState = 0;
  String deviceId = '';

  @override
  void initState() {
    super.initState();
    fetchActuatorState();
  }

  Future<void> fetchActuatorState() async {
    final deviceQuery = await FirebaseFirestore.instance
        .collection('devices')
        .where('name', isEqualTo: widget.deviceName)
        .get();
    deviceId = deviceQuery.docs.first.id;

    final snapshot = await FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .get();

    if (snapshot.exists) {
      final data = snapshot.data() as Map<String, dynamic>;
      setState(() {
        actuatorState = data['state'] ?? 0;
      });
    }
  }

  Future<void> toggleActuatorState() async {
    final newActuatorState = actuatorState == 0 ? 1 : 0;

    final deviceQuery = await FirebaseFirestore.instance
        .collection('devices')
        .where('name', isEqualTo: widget.deviceName)
        .get();
    String deviceId = deviceQuery.docs.first.id;

    await FirebaseFirestore.instance
        .collection('devices')
        .doc(deviceId)
        .update({'state': newActuatorState});

    setState(() {
      actuatorState = newActuatorState;
    });
  }

  @override
  Widget build(BuildContext context) {
    Color buttonColor = actuatorState == 0 ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          '${widget.deviceName}',
          style: TextStyle(color: Colors.black),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: ElevatedButton(
              onPressed: toggleActuatorState,
              style: ElevatedButton.styleFrom(
                primary: buttonColor,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
              child: Text(
                actuatorState == 1 ? 'ON' : 'OFF',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            'Liste des événements :',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Expanded(
    child: StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('devices')
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        // Find the actuator device document
        DocumentSnapshot? actuatorDevice;
        for (var document in snapshot.data!.docs) {
          if (document['name'] == widget.deviceName) {
            actuatorDevice = document;
            break;
          }
        }

        if (actuatorDevice == null) {
          return Text('Actuator device not found');
        }

        // Get the 'events' subcollection from the actuator device document
        return StreamBuilder<QuerySnapshot>(
          stream: actuatorDevice.reference
              .collection('events')
              .orderBy('timestamp', descending: true)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> eventsSnapshot) {
            if (eventsSnapshot.hasError) {
              return Text('Error: ${eventsSnapshot.error}');
            }

            if (eventsSnapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }

            if (eventsSnapshot.data!.docs.isEmpty) {
              return Text('Aucun événement trouvé.');
            }

            return ListView.builder(
              itemCount: eventsSnapshot.data!.docs.length,
              itemBuilder: (BuildContext context, int index) {
                final event = eventsSnapshot.data!.docs[index];
                final state = event['state'];
                final timestamp = event['timestamp'];

                return ListTile(
                  leading: Icon(
                    state == 1 ? Icons.check : Icons.close,
                    color: state == 1 ? Colors.green : Colors.red,
                  ),
                  title: Text(
                    state == 1 ? 'L\'appareil ' + widget.deviceName +' a été allumé' : 'L\'appareil ' + widget.deviceName +' a été éteint',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Date: ${DateTime.fromMillisecondsSinceEpoch(timestamp)}',
                      ),
                    );
                  },
                );
              },
                      );
      },
            ),
          ),
        ],
      ),
    );
  }
}












// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class ActuatorPage extends StatefulWidget {
//   final String deviceName;

//   const ActuatorPage({Key? key, required this.deviceName}) : super(key: key);

//   @override
//   State<ActuatorPage> createState() => _ActuatorPageState();
// }

// class _ActuatorPageState extends State<ActuatorPage> {
//   int actuatorState = 0;

//   @override
//   void initState() {
//     super.initState();
//     fetchActuatorState();
//   }

//   Future<void> fetchActuatorState() async {
//     final deviceQuery = await FirebaseFirestore.instance
//         .collection('devices')
//         .where('name', isEqualTo: widget.deviceName)
//         .get();
//     String deviceId = deviceQuery.docs.first.id;

//     final snapshot = await FirebaseFirestore.instance
//         .collection('devices')
//         .doc(deviceId)
//         .get();

//     if (snapshot.exists) {
//       final data = snapshot.data() as Map<String, dynamic>;
//       setState(() {
//         actuatorState = data['state'] ?? 0;
//       });
//     }
//   }

//   Future<void> toggleActuatorState() async {
//     final newActuatorState = actuatorState == 0 ? 1 : 0;

//     final deviceQuery = await FirebaseFirestore.instance
//         .collection('devices')
//         .where('name', isEqualTo: widget.deviceName)
//         .get();
//     String deviceId = deviceQuery.docs.first.id;

//     await FirebaseFirestore.instance
//         .collection('devices')
//         .doc(deviceId)
//         .update({'state': newActuatorState});

//     setState(() {
//       actuatorState = newActuatorState;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     Color buttonColor = actuatorState == 0 ?  Colors.red:Colors.green;

//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         title: Text(
//           '${widget.deviceName}',
//           style: TextStyle(color: Colors.black),
//           textAlign: TextAlign.center,
//         ),
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Stack(
//         children : [
//           Column(
//             children: [
//               ElevatedButton(
//               onPressed: toggleActuatorState,
//               style: ElevatedButton.styleFrom(
//                 primary: buttonColor,
//                 padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),   
//               ),
//               child: Text(
//                 actuatorState == 1 ?  'ON': 'OFF',
//                 style: TextStyle(fontSize: 20),
//               ),
//             ),
//           ],  
//           )
//         ]
//       )
//     );
//   }
// }






















