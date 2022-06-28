import 'package:audit_p/Home_Page.dart';
import 'package:audit_p/Provider/Provider_Helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return   MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SQLHealper()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:Home_Page() ,

      ),
    );



  }
}
