import 'package:firebase_remote_config_example/device_inspector.dart';
import 'package:firebase_remote_config_example/device_inspector_bloc.dart';
import 'package:firebase_remote_config_example/injection_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MasterPage(),
    );
  }
}

class MasterPage extends StatelessWidget {
  const MasterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeviceInspectorBloc>(
      create: (context) => sl(),
      child: BlocListener<DeviceInspectorBloc, DeviceInspectorState>(
        listener: (context, state) {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const UserPage(),
          ));
        },
        child: Scaffold(
          body: Container(),
        ),
      ),
    );
  }
}

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: sl<DeviceInspector>(),
      ),
    );
  }
}
