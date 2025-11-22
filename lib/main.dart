import 'package:flutter/material.dart';
import 'package:flutter_rotation_sensor/flutter_rotation_sensor.dart';
import 'dart:math';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Euler Angle Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: EulerAngleDisplayScreen(),
    );
  }
}

class EulerAngleDisplayScreen extends StatefulWidget {
  @override
  _EulerAngleDisplayScreenState createState() => _EulerAngleDisplayScreenState();
}

class _EulerAngleDisplayScreenState extends State<EulerAngleDisplayScreen> {
  // Use pi for radians to degrees conversion
  static const double RADIAN_TO_DEGREE = 180 / pi;

  @override
  void initState() {
    super.initState();
    // Optional: Set the sampling period (e.g., for faster updates)
    RotationSensor.samplingPeriod = SensorInterval.gameInterval;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Device Orientation (Euler Angles)')),
      body: Center(
        child: StreamBuilder<OrientationEvent>(
          // The orientationStream provides real-time sensor data
          stream: RotationSensor.orientationStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // Accessing the Euler angles from the OrientationEvent
              final eulerAngles = snapshot.data!.eulerAngles;

              // Convert radians to degrees for readability
              final azimuth = eulerAngles.azimuth * RADIAN_TO_DEGREE;
              final pitch = eulerAngles.pitch * RADIAN_TO_DEGREE;
              final roll = eulerAngles.roll * RADIAN_TO_DEGREE;

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Real-time Euler Angles (Degrees):',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text('Azimuth (Yaw): ${azimuth.toStringAsFixed(2)}°'),
                    Text('Pitch: ${pitch.toStringAsFixed(2)}°'),
                    Text('Roll: ${roll.toStringAsFixed(2)}°'),
                    const SizedBox(height: 30),
                    const Text(
                      'Azimuth: Rotation around the Z-axis (North/Compass).\n'
                      'Pitch: Rotation around the X-axis (tilting the phone).\n'
                      'Roll: Rotation around the Y-axis (side-to-side tilt).',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text('Error accessing sensor data: ${snapshot.error}');
            }
            
            // Show a loading indicator while waiting for the first data point
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}