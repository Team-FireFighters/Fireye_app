import 'package:fireye/providers/global_provider.dart';
import 'package:fireye/screens/dashboard/pages/dashboard_page.dart';
import 'package:fireye/screens/location/pages/location_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GlobalProvider(),)
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark(
          useMaterial3: true,
          
        ),
        home: const DashboardPage(),
        // home: LocationPage(),
      ),
    );
  }
}