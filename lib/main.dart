import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      create: (context) => Counter(),
      child: const MyApp(),
    ),
  );
}

const double windowWidth = 360;
const double windowHeight = 640;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Provider Counter');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

class Counter with ChangeNotifier {
  int _age = 0;

  int get age => _age;

  void setAge(double value) {
    _age = value.toInt();
    notifyListeners();
  }

  void increment() {
    _age += 1;
    notifyListeners();
  }

  void decrement() {
    if (_age > 0) {
      _age -= 1;
      notifyListeners();
    }
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Age Counter'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Consumer<Counter>(
              builder: (context, counter, child) => Text(
                'I am ${counter.age} years old',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 20),
            Consumer<Counter>(
              builder: (context, counter, child) => Slider(
                value: counter.age.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  counter.setAge(value);
                },
              ),
            ),
            ElevatedButton(
              onPressed: () {
                var counter = context.read<Counter>();
                counter.increment();
              },
              child: const Text("Increment"),
            ),
            ElevatedButton(
              onPressed: () {
                var counter = context.read<Counter>();
                counter.decrement();
              },
              child: const Text("Decrement"),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          var counter = context.read<Counter>();
          counter.increment();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
