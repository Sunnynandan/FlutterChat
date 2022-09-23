import 'package:firebase/Auth.dart';
import 'package:firebase/Chat_Screen.dart';
import 'package:firebase/MainScreen.dart';
import 'package:firebase/update_profile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'Auth_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    ChangeNotifierProvider(create: (context) => Data(), child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            drawerTheme: DrawerThemeData(),
            listTileTheme: ListTileThemeData(
              textColor: Colors.black,
              contentPadding: const EdgeInsets.all(4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
              tileColor: const Color(0xFFD7E5F0),
            ),
            snackBarTheme: SnackBarThemeData(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              actionTextColor: Colors.white,
              backgroundColor: Colors.red,
              contentTextStyle:
                  GoogleFonts.oswald(fontSize: 15, color: Colors.white),
            ),
            appBarTheme: const AppBarTheme(
              elevation: 0,
              backgroundColor: Color(0xFF1E2A56),
            ),
            textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
              textStyle: const TextStyle(
                color: Color(0xFF1E2A56),
                fontSize: 15,
              ),
            )),
            textTheme: TextTheme(
                headline1: GoogleFonts.barlow(
              fontSize: 30,
              color: Colors.white,
            )),
            outlinedButtonTheme: OutlinedButtonThemeData(
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(15),
                    shape: const StadiumBorder(),
                    side: const BorderSide(
                      color: Color(0xFF1E2A56),
                      width: 2.5,
                    ),
                    foregroundColor: const Color(0xFF1E2A56),
                    textStyle: GoogleFonts.oswald(
                        fontSize: 18,
                        color: const Color(0xFF1E2A56),
                        fontWeight: FontWeight.w500)))),
        routes: {
          AuthPage.authpage: (context) => AuthPage(),
          chatscreen.chatpage: (context) => chatscreen(),
          UpdatePro.updateProf: (context) => UpdatePro(),
        },
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) =>
              (snapshot.hasData) ? const MainScreen() : AuthPage(),
        ));
  }
}
