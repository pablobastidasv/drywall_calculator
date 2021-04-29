import 'package:drywall_calculator_dart/route_generator.dart';
import 'package:flutter/material.dart';

import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final routerGenerator = RouteGenerator();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de materiales',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.yellow,
        accentColor: Colors.yellow.shade800,
      ),
      initialRoute: '/',
      onGenerateRoute: this.routerGenerator.generateRoute,
    );
  }

  @override
  void dispose() {
    this.routerGenerator.dispose();
    super.dispose();
  }
}
