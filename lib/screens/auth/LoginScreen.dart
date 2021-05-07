import 'package:apes/constants/Colors.dart' as Palette;
import 'package:apes/misc/MaterialStatePropertyColor.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _isPasswordVisible = false;
  String? _loginError;

  //Form data
  String? _email;
  String? _password;

  bool _isLogginIn = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: SvgPicture.asset(
          "assets/logo.svg",
          height: 35,
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          Text(
            "Welcome Back!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Glad to see you again!",
            style: TextStyle(color: Palette.grey),
          ),
          SizedBox(height: 24),
          _buildForm(context),
          SizedBox(height: 24),
          // Forgot password
          Center(
            child: Text(
              "Forgot Password?",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Palette.grey,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ),
          Divider(
            height: 48,
            thickness: 1,
            indent: 30,
            endIndent: 30,
            color: Colors.black.withOpacity(0.2),
          ),
          _buildAlternativeAuthOptions(context),
          SizedBox(height: 48),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: TextStyle(
                color: Palette.grey,
                fontSize: 12,
              ),
              children: [
                TextSpan(text: 'By signing in you agree to '),
                TextSpan(
                  text: 'Terms of Condition',
                  style: TextStyle(decoration: TextDecoration.underline),
                  // recognizer: TapGestureRecognizer()
                  //   ..onTap = () {
                  //     print('Terms of Service"');
                  //   },
                ),
                TextSpan(text: " and "),
                TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(decoration: TextDecoration.underline),
                  // recognizer: TapGestureRecognizer()
                  //   ..onTap = () {
                  //     print('Terms of Service"');
                  //   },
                ),
                TextSpan(text: "."),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Email Input
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.mail_outline),
              hintText: "bruce.wayne@WayneEnterprises.com",
              hintStyle: TextStyle(fontSize: 14),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: MultiValidator([
              RequiredValidator(errorText: 'Email is required'),
              EmailValidator(errorText: "Invalid Email"),
              // PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
            ]),
            onSaved: (value) => setState(() {
              _email = value;
            }),
            enabled: !_isLogginIn,
          ),
          SizedBox(height: 8),
          // Password Input
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock_open),
              hintText: "•••••••••",
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
              ),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: !_isPasswordVisible,
            validator: MultiValidator([
              RequiredValidator(errorText: 'Password is required'),
              MinLengthValidator(8, errorText: 'Password must be at least 8 digits long'),
              // PatternValidator(r'(?=.*?[#?!@$%^&*-])', errorText: 'passwords must have at least one special character')
            ]),
            onSaved: (value) => setState(() {
              _password = value;
            }),
            enabled: !_isLogginIn,
          ),
          // On Error
          if (_loginError != null) ...[
            SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                _loginError ?? "",
                style: TextStyle(
                  color: Palette.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            SizedBox(height: 8),
          ],
          SizedBox(height: 16),
          // Submit Button
          Container(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              child: Text(
                "Login",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              onPressed: () {
                final bool isValid = _formKey.currentState?.validate() ?? false;
                if (isValid) {
                  _formKey.currentState?.save();
                  _handleEmailLogin();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlternativeAuthOptions(BuildContext context) {
    return Column(
      children: [
        // Google Sign-in
        Container(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: materialStatePropertyColor(color: Color(0xFF202124)),
            ),
            label: Text("Continue using Google"),
            icon: FaIcon(
              FontAwesomeIcons.google,
              size: 20,
            ),
            onPressed: () {
              _handleGoogleLogin();
            },
          ),
        ),
        SizedBox(height: 12),
        // Facebook Sign-In
        Container(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: materialStatePropertyColor(color: Color(0xFF4267B2)),
            ),
            label: Text("Continue using Facebook"),
            icon: FaIcon(
              FontAwesomeIcons.facebookF,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
        SizedBox(height: 12),
        // Twitter Sign-In
        Container(
          width: double.infinity,
          height: 48,
          child: ElevatedButton.icon(
            style: ButtonStyle(
              backgroundColor: materialStatePropertyColor(color: Color(0xFF00ACEE)),
            ),
            label: Text("Continue using Twitter"),
            icon: FaIcon(
              FontAwesomeIcons.twitter,
              size: 20,
            ),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  void _handleEmailLogin() async {
    String? error;
    setState(() {
      _isLogginIn = true;
    });
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email ?? "",
        password: _password ?? "",
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = "No user found for that email.";
      } else if (e.code == 'wrong-password') {
        error = "Wrong password provided for that user.";
      } else {
        error = "Unknown error.";
      }
    } finally {
      setState(() {
        _loginError = error;
        _isLogginIn = true;
      });
    }
  }

  Future<UserCredential> _handleGoogleLogin() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
}
