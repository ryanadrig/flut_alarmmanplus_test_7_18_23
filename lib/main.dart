
import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:isolate';
import 'dart:ui';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'flog.dart';



FileOutput flog = FileOutput();



/// The name associated with the UI isolate's [SendPort].
const String isolateName = 'isolate';
/// A port used to communicate from a background isolate to the UI isolate.
ReceivePort port = ReceivePort();

// The background
SendPort? uiSendPort;

int runno = 0;

// Must be static or top level
@pragma('vm:entry-point')
Future<void> printHello() async {
final DateTime now = DateTime.now();
// final int isolateId = Isolate.current.hashCode;
// print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");

  runno += 1;
  await flog.init();
  await flog.lg("test init flog 89");
  await flog.lg(now.toIso8601String() +" ~ FRepeat Alarm Fired " + runno.toString() +" times");

  uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
  uiSendPort?.send(null);
// await flog.lg("~ FAlarm Fired ~ Time: $now ~ IsolateID: test");
}


Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  IsolateNameServer.registerPortWithName(
    port.sendPort,
    isolateName,
  );

  await flog.init();
  await flog.lg("test init flog 44");

  ///
  /// run single task
  ///
  // Future<void> _runOneShotCallback() async{
  //   print("run one shot (( ran ))");
  //   await flog.lg("~ FAlarm OneShot Fired 3 ~");
  // }
  //
  // await AndroidAlarmManager.initialize();
  // port.listen((_) async => await _runOneShotCallback());
  //
  // // The background
  // SendPort? uiSendPort;
  //
  // // Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
  // @pragma('vm:entry-point')
  // Future<void> printHello() async {
  //   // final DateTime now = DateTime.now();
  //   // final int isolateId = Isolate.current.hashCode;
  //   // print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  //
  //   await flog.init();
  //   await flog.lg("test init flog 4");
  //   await flog.lg("~ FAlarm Fired 5 ~");
  //   uiSendPort ??= IsolateNameServer.lookupPortByName(isolateName);
  //   uiSendPort?.send(null);
  //   // await flog.lg("~ FAlarm Fired ~ Time: $now ~ IsolateID: test");
  // }
  //
  //
  // Future<void> _runOneShot() async{
  //   print("run one shot call");
  //   await AndroidAlarmManager.oneShot(
  //     const Duration(seconds: 5),
  //     Random().nextInt(pow(2,8) as int),
  //     printHello,
  //     exact: true,
  //     wakeup: true,
  //   );
  // }
  //
  // await _runOneShot();

  /// run periodic task
  // final int helloAlarmID = 0;
  // await AndroidAlarmManager.periodic(const Duration(seconds: 5), helloAlarmID, printHello);



  runApp(const MyApp());

}

class MyApp extends StatelessWidget {



  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  @override
  void initState() {

    super.initState();

    AndroidAlarmManager.initialize();
    port.listen((_) async => await _runOneShotCallback());

  }


  Future<void> _runOneShotCallback() async{
    print("run one shot (( ran ))");
    await flog.lg("~ FAlarm OneShot Fired 33 ~");
  }





  @override
  Widget build(BuildContext context) {

    Future<void> _runOneShot() async{
      print("run one shot call");
      await AndroidAlarmManager.oneShot(
        const Duration(seconds: 5),
          Random().nextInt(pow(2,8) as int),
        printHello,
        exact: true,
        wakeup: true,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Schedule task',
            ),
            Text(
              'Stuff ',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed:(){
          print("ros");
          // _runOneShot();

          AndroidAlarmManager.periodic(const Duration(minutes: 1), 667, printHello);
          },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
