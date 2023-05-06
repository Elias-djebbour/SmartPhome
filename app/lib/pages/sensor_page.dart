import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorPage extends StatefulWidget {
  final String deviceName;
  const SensorPage({super.key, required this.deviceName});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.deviceName} Devices'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('devices')
            .where('type', isEqualTo: 'sensor')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }

          // Find the temperature sensor document
          DocumentSnapshot? temperatureSensor;
          for (var document in snapshot.data!.docs) {
            if (document['name'] == widget.deviceName) {
              temperatureSensor = document;
              break;
            }
          }

          if (temperatureSensor == null) {
            return const Text('Temperature sensor not found');
          }

          // Get the 'values' subcollection from the temperature sensor document
          return StreamBuilder<QuerySnapshot>(
            stream: temperatureSensor.reference.collection('values').snapshots(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> temperatureSnapshot) {
              if (temperatureSnapshot.hasError) {
                return Text('Error: ${temperatureSnapshot.error}');
              }

              if (temperatureSnapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              }

              // Assuming the temperature field in the values subcollection is named 'value'
              Map<String, dynamic> temperature =
                  temperatureSnapshot.data!.docs.first['temperature'];

              if (temperature == null || !temperature.containsKey('value')) {
                return const Text('Temperature data not available');
              }

              int temperatureValue = temperature['value'];

              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.thermostat,
                      size: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      '$temperatureValue°C',
                      style: TextStyle(fontSize: 24),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}




















/*
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SensorPage extends StatefulWidget {
  final String deviceName;
  const SensorPage({super.key, required this.deviceName});

  @override
  State<SensorPage> createState() => _SensorPageState();
}

class _SensorPageState extends State<SensorPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('${widget.deviceName} Devices'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('devices')
              .where('type', isEqualTo: 'sensor')
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            // Find the temperature sensor document
            DocumentSnapshot? temperatureSensor;
            for (var document in snapshot.data!.docs) {
              if (document['name'] == widget.deviceName) {
                temperatureSensor = document;
                break;
              }
            }

            if (temperatureSensor == null) {
              return const Text('Temperature sensor not found');
            }

            // Get the 'values' subcollection from the temperature sensor document
            return StreamBuilder<QuerySnapshot>(
              stream:
                  temperatureSensor.reference.collection('values').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> temperatureSnapshot) {
                if (temperatureSnapshot.hasError) {
                  return Text('Error: ${temperatureSnapshot.error}');
                }

                if (temperatureSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                // Assuming the temperature field in the values subcollection is named 'value'
                Map<String, dynamic> temperature =
                    temperatureSnapshot.data!.docs.first['temperature'];
                

                return Text(
                  'Temperature: $temperature°C',
                  style: TextStyle(fontSize: 24),
                );
              },
            );
          },
        ));
  }
}
*/