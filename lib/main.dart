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

  Color get backgroundColor {
    if (_age <= 33) {
      return Colors.green;
    } else if (_age <= 67) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

 String get ageMessage {
    if (_age <= 10) {
      return "You're a kid";
    } else if (_age <= 20) {
      return "Teen years";
    } else if (_age <= 33) {
      return "Life is ramping up";
    } else if (_age <= 50) {
      return "In your prime";
    } 
     else {
      return "You've lived a long full life";
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
    return Consumer<Counter>(
      builder: (context, counter, child) => Scaffold(
        backgroundColor: counter.backgroundColor, 
        appBar: AppBar(
          title: const Text('Age Counter'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'I am ${counter.age} years old',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
               const SizedBox(height: 10),
              Text(
                counter.ageMessage,  // Display age-specific message
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Slider(
                value: counter.age.toDouble(),
                min: 0,
                max: 100,
                divisions: 100,
                onChanged: (value) {
                  counter.setAge(value);
                },
              ),
              ElevatedButton(
                onPressed: () {
                  counter.increment();
                },
                child: const Text("Increment"),
              ),
              ElevatedButton(
                onPressed: () {
                  counter.decrement();
                },
                child: const Text("Decrement"),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            counter.increment();
          },
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
