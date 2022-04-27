import 'package:flutter/material.dart';
import 'package:movie_mate/screens/wrapper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:movie_mate/service/auth.dart';
import 'package:provider/provider.dart';

import 'models/user.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}



class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override

  Widget build(BuildContext context) {
    // This widget is the root of your application.
    return StreamProvider<Users?>.value(
      value: AuthService().user,
        initialData: null,
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            // This is the theme of the application.
            // scaffoldBackgroundColor: kBackgroundColor,`
            // primaryColor: kPrimaryColor,
            textTheme: GoogleFonts.workSansTextTheme(
              Theme.of(context).textTheme,
            ),
            // This makes the visual density adapt to the platform that you run
            // the app on. For desktop platforms, the controls will be smaller and
            // closer together (more dense) than on mobile platforms.
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: const Wrapper(),
        )
    );
  }
}
