import 'package:flutter/material.dart';
import 'register.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/services.dart';
import 'dart:io'
    show
        Platform; //Information about the environment in which the current program is running.
import 'home_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // running on the web!

import 'package:screen_loader/screen_loader.dart';
// importing firebase libraries
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

const String username = '';
const String password = '';
final client = MqttServerClient('mqtt.cetools.org', 'LeoLiu');

double Today = 1.0;
String TotalStartTime = '2022-11-16';
double Yesterday = 1.0;
double Total = 1.0;
int Power = 0;
int ApparentPower = 0;
int ReactivePower = 0;
String Time = '2022-11-16';
int Voltage = 236;
double Current = 1.0;
int Period = 0;
double Factor = 1.0;

//Prevent device orientation changes and force portrait up and down
main() async {
  //Global loading screen
  configScreenLoader(
    loader: AlertDialog(
      title: Text('Connecting to MQTT...'),
    ),
    bgBlur: 20.0,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
    //runs the app
  ]).then((_) => runApp(MyApp()));
}

// implements the app
// extend here allows App to inherit properties and methods from StatelessWidget
//change the status bar colour to transparent
class MyApp extends StatelessWidget {
  // @override helps to identify inherited methods or variables
  // that are being replaced in the subclass
  @override
  // builds the widget
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
      title: 'Energy Diary',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        platform: TargetPlatform.iOS,
      ),
      routes: {
        "/": (context) => const loginPage(title: "Log in"), // login page
      },
    );
  }
}

class AuthService {
  Future<String?> registration({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return 'Success';
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        return 'Wrong password provided for that user.';
      } else {
        return e.message;
      }
    } catch (e) {
      return e.toString();
    }
  }
}

class loginPage extends StatefulWidget {
  const loginPage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> with ScreenLoader {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _isObscure = true;
  Color _eyeColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            const SizedBox(height: kToolbarHeight), // Padding
            buildTitle(), // Login
            buildTitleLine(), // The line underneath the Login title
            const SizedBox(height: 60),
            buildEmailTextField(), // Enter your email address
            const SizedBox(height: 30),
            buildPasswordTextField(context), // Enter your password

            const SizedBox(height: 60),
            buildLoginButton(context), // Login button
            const SizedBox(height: 40),

            buildRegisterText(context), // Register
          ],
        ),
      ),
    );
  }

  Widget buildRegisterText(context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('To create an account - '),
            GestureDetector(
              child: const Text('Register here',
                  style: TextStyle(color: Colors.green)),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) =>
                        const registrationPage(title: "Sign up"),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45,
        width: 270,
        child: ElevatedButton(
          style: ButtonStyle(
              // circular corner
              shape: MaterialStateProperty.all(const StadiumBorder(
                  side: BorderSide(style: BorderStyle.none)))),
          child: Text('Login',
              style: Theme.of(context).primaryTextTheme.headlineSmall),
          onPressed: () async {
            final message = await AuthService().login(
              email: _email.text,
              password: _password.text,
            );
            if (message!.contains('Success')) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const MyHomePage(),
                ),
              );
            }
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildPasswordTextField(BuildContext context) {
    return TextFormField(
        obscureText: _isObscure, // show entered password
        controller: _password,
        validator: (v) {
          if (v!.isEmpty) {
            return 'Please enter your password';
          }
        },
        decoration: InputDecoration(
            labelText: "Password",
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                //  setState()
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = (_isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color)!;
                });
              },
            )));
  }

  Widget buildEmailTextField() {
    return TextFormField(
      decoration: const InputDecoration(labelText: 'Email Address'),
      validator: (v) {
        var emailReg = RegExp(
            r"[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?");
        if (!emailReg.hasMatch(v!)) {
          return 'Please enter a correct email address';
        }
      },
      controller: _email,
    );
  }

  Widget buildTitleLine() {
    return Padding(
        padding: const EdgeInsets.only(left: 12.0, top: 4.0),
        child: Align(
          alignment: Alignment.bottomLeft,
          child: Container(
            color: Colors.black,
            width: 40,
            height: 2,
          ),
        ));
  }

  Widget buildTitle() {
    return const Padding(
        padding: EdgeInsets.all(8),
        child: Text(
          'Login',
          style: TextStyle(fontSize: 42),
        ));
  }
}

class User {
  String TotalStartTime;
  double Total;
  double Yesterday;
  double Today;
  int Period;
  int Power;
  int ApparentPower;
  int ReactivePower;
  double Factor;
  int Voltage;
  double Current;

  User(
      this.TotalStartTime,
      this.Total,
      this.Yesterday,
      this.Today,
      this.Period,
      this.Power,
      this.ApparentPower,
      this.ReactivePower,
      this.Factor,
      this.Voltage,
      this.Current);

  factory User.fromJson(dynamic json) {
    return User(
        json['TotalStartTime'] as String,
        json['Total'] as double,
        json['Yesterday'] as double,
        json['Today'] as double,
        json['Period'] as int,
        json['Power'] as int,
        json['ApparentPower'] as int,
        json['ReactivePower'] as int,
        json['Factor'] as double,
        json['Voltage'] as int,
        json['Current'] as double);
  }

  @override
  String toString() {
    return '{ ${this.TotalStartTime}, ${this.Total},${this.Yesterday}, ${this.Today}, ${this.Period}, ${this.Power}, ${this.ApparentPower}, ${this.ReactivePower}, ${this.Factor}, ${this.Voltage}, ${this.Current} }';
  }
}

class Tutorial {
  final String Time;
  final User ENERGY;

  Tutorial(this.Time, this.ENERGY);

  factory Tutorial.fromJson(dynamic json) {
    return Tutorial(json['Time'] as String, User.fromJson(json['ENERGY']));
  }

  @override
  String toString() {
    return '{ ${this.Time}, ${this.ENERGY}}';
  }
}
