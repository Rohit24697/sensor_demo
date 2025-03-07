import 'package:flutter/material.dart';
import 'package:sensor_demo/profile_page.dart';
import 'package:sensor_demo/sensor_demo_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => SensorDemoPage()));
                },
                child: Text(
                  "Sensor Demo",
                  style: TextStyle(fontSize: 20.0),
                )),
            SizedBox(
              height: 20.0,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePage()));
                },
                child: Text(
                  "Profile",
                  style: TextStyle(fontSize: 20.0),
                )),
          ],
        ),
      )),
    );
  }
}
