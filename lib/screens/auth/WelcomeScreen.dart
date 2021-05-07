import 'package:apes/constants/Colors.dart' as Palette;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Spacer(flex: 3),
            Center(child: SvgPicture.asset("assets/logo.svg")),
            Spacer(flex: 2),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                children: [
                  Text(
                    "No more lonely days!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Sign in and find your couple now!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Palette.grey,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 48),
            Container(
              width: double.infinity,
              height: 48,
              child: OutlinedButton(
                child: Text(
                  "Do you already have an account?",
                  style: TextStyle(color: Palette.darkGrey),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/auth/login");
                },
              ),
            ),
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                child: Text(
                  "Get Started",
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed("/auth/register");
                },
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
