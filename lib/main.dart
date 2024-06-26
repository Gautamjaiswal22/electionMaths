import 'package:chunavganit/homePage.dart';
import 'package:chunavganit/register.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String logindocId = '';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // String docId = '';
  checkId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    logindocId = await prefs.getString('docId') ?? "";
    print("docId $logindocId");
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkId();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: logindocId == "" ? SignUpPage() : HomePage(),
    );
  }
}
