import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorDemoPage extends StatefulWidget {
  const SensorDemoPage({super.key});

  @override
  State<SensorDemoPage> createState() => _SensorDemoPageState();
}

class _SensorDemoPageState extends State<SensorDemoPage> {

  AccelerometerEvent? _accelerometerEvent;
  StreamSubscription<AccelerometerEvent>? _accelerometerSubscription;
  @override
  void initState(){
    super.initState();
    _accelerometerSubscription =accelerometerEventStream().listen((event){
      print(event);

      setState(() {
        _accelerometerEvent=event;

      });

    });


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text("Accelerometer Demo")),
      body: Center(
        child: SafeArea(
          child: Column(
            crossAxisAlignment:CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Accelerometer value",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.0),
              Text("x:${_accelerometerEvent?.x.toStringAsFixed(3)}",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20.0),
              Text("y:${_accelerometerEvent?.y.toStringAsFixed(3)}",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20.0),
              Text("z:${_accelerometerEvent?.z.toStringAsFixed(3)}",
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
              ),

              SizedBox(height: 20.0),
              Text(
                "Move your device around to see the accelerometer values change!",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18,fontWeight: FontWeight.normal),

              ),
            ],
          ),
        ),
      ),);
  }
}