import '../provider/adminMode.dart';
import '../screens/admin/adminHome.dart';
import '../screens/signup_screen.dart';
import '../screens/user/homePage.dart';
import '../widgets/custom_textfield.dart';
import '../widgets/cutsom_logo.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import '../services/auth.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../provider/modelHud.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'LoginScreen';
  final GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email = 'abdou@gmail.com', password = '123456';

  final _auth = Auth();

  final adminPassword = '123456';

  bool keepMeLoggedIn = false;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: kMainColor,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: widget.globalKey,
          child: ListView(
            children: <Widget>[
              CustomLogo(),
              SizedBox(height: height * .1),
              CustomTextField(
                onClick: (value) {
                  _email = value!;
                },
                initialValue: _email,
                hint: 'Enter your email',
                icon: Icons.email,
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Row(
                  children: <Widget>[
                    Theme(
                      data: ThemeData(unselectedWidgetColor: Colors.black),
                      child: Checkbox(
                        checkColor: kSecondaryColor,
                        activeColor: kBnbColorAccentDark,
                        value: keepMeLoggedIn,
                        onChanged: (value) {
                          setState(() {
                            keepMeLoggedIn = value!;
                          });
                        },
                      ),
                    ),
                    Text('Remmeber Me ', style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
              CustomTextField(
                onClick: (value) {
                  password = value!;
                },
                hint: 'Enter your password',
                icon: Icons.lock,
                initialValue: password,
              ),
              SizedBox(height: height * .05),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Builder(
                  builder:
                      (context) => MaterialButton(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        onPressed: () {
                          if (keepMeLoggedIn == true) {
                            keepUserLoggedIn();
                          }
                          _validate(context);
                        },
                        color: kBnbColorAccentDark,
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                ),
              ),
              SizedBox(height: height * .05),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Don\'t have an account ? ',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, SignupScreen.id);
                    },
                    child: Text(
                      'Signup',
                      style: TextStyle(
                        fontSize: 16,
                        color: kBnbColorAccentDark,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(
                            context,
                            listen: false,
                          ).changeIsAdmin(true);
                        },
                        child: Text(
                          'I\'m An Admin',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Provider.of<AdminMode>(context).isAdmin
                                    ? kMainColor
                                    : Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Provider.of<AdminMode>(
                            context,
                            listen: false,
                          ).changeIsAdmin(false);
                        },
                        child: Text(
                          'I\'m A User',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color:
                                Provider.of<AdminMode>(
                                      context,
                                      listen: true,
                                    ).isAdmin
                                    ? Colors.black
                                    : kMainColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _validate(BuildContext context) async {
    final modelhud = Provider.of<ModelHud>(context, listen: false);
    modelhud.changeisLoading(true);
    if (widget.globalKey.currentState!.validate()) {
      widget.globalKey.currentState!.save();
      if (Provider.of<AdminMode>(context, listen: false).isAdmin) {
        if (password == adminPassword) {
          print('Hello Abdou');
          try {
            await _auth.signIn(_email.trim(), password.trim());
            Navigator.pushNamed(context, AdminHome.id);
          } catch (e) {
            modelhud.changeisLoading(false);
            SnackBar(content: Text(e.toString()));
            print('Im not Abdou');
          }
        } else {
          modelhud.changeisLoading(false);
          print('Something went wrong !');
          SnackBar(content: Text('Something went wrong !'));
        }
      } else {
        try {
          await _auth.signIn(_email.trim(), password.trim());
          Navigator.pushNamed(context, HomePage.id);
          print('Hello User');
          // } catch (e) {
        } on PlatformException catch (e) {
          SnackBar(content: Text(e.message.toString()));
          print('Something went wrong 2!');
        }
      }
    }
    modelhud.changeisLoading(false);
  }

  void keepUserLoggedIn() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(kKeepMeLoggedIn, keepMeLoggedIn);
  }
}
