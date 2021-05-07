import 'package:apes/constants/Colors.dart' as Palette;
import 'package:apes/screens/BottomBarNavigator.dart';
import 'package:apes/screens/auth/LoginScreen.dart';
import 'package:apes/screens/auth/WelcomeScreen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'misc/MaterialStatePropertyColor.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeData theme = ThemeData(
    primaryColor: Palette.red,
    scaffoldBackgroundColor: Colors.white,
    fontFamily: "TTNorms",
    iconTheme: IconThemeData(
      color: Palette.grey,
    ),
    primaryIconTheme: IconThemeData(
      color: Palette.grey,
    ),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: materialStatePropertyColor(color: Palette.red),
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apes - Dating App',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: EntryPoint(),
      onGenerateRoute: _onGenerateRoute,
    );
  }

  Route<dynamic> _onGenerateRoute(RouteSettings settings) {
    // final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => AuthCheckEntryPoint());

      case "/auth/welcome":
        return MaterialPageRoute(builder: (_) => WelcomeScreen());

      case "/auth/login":
        return MaterialPageRoute(builder: (_) => LoginScreen());

      default:
        return MaterialPageRoute(builder: (context) => _errorRoute(context));
    }
  }

  Widget _errorRoute(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "Route not found",
          style: TextStyle(
            color: Colors.red,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class EntryPoint extends StatefulWidget {
  @override
  _EntryPointState createState() => _EntryPointState();
}

class _EntryPointState extends State<EntryPoint> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return _buildErrorPage(context);
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return AuthCheckEntryPoint();
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return _buildLoadingScreen(context);
      },
    );
  }

  Widget _buildLoadingScreen(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 7),
          Center(child: SvgPicture.asset("assets/logo.svg")),
          Spacer(flex: 6),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.red),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Please wait...",
            style: TextStyle(color: Palette.grey),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }

  Widget _buildErrorPage(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Spacer(flex: 7),
          Center(child: SvgPicture.asset("assets/logo.svg")),
          Spacer(flex: 6),
          SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.red),
              strokeWidth: 3,
            ),
          ),
          SizedBox(height: 24),
          Text(
            "Please wait...",
            style: TextStyle(color: Palette.grey),
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class AuthCheckEntryPoint extends StatefulWidget {
  AuthCheckEntryPoint({Key? key}) : super(key: key);

  @override
  _AuthCheckEntryPointState createState() => _AuthCheckEntryPointState();
}

class _AuthCheckEntryPointState extends State<AuthCheckEntryPoint> {
  User? _currentUser;

  @override
  void initState() {
    super.initState();
    _registerAuthListener();
  }

  @override
  Widget build(BuildContext context) {
    return (_currentUser == null) ? WelcomeScreen() : BottomBarNavigator();
  }

  void _registerAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      setState(() {
        _currentUser = user;
      });
    });
  }
}
