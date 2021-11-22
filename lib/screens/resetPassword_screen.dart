import 'package:flutter/material.dart';
import 'package:grocery_vendor/provider/auth_provider.dart';
import 'package:grocery_vendor/screens/login_screen.dart';
import 'package:provider/provider.dart';

class ResetPassword extends StatefulWidget {
  static const String id = 'reset-screen';

  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  String email;
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    scafflodMessage(message) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    "images/reset.png",
                    height: 250,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  RichText(
                    text: TextSpan(text: '', children: [
                      TextSpan(
                        text: 'Forgot Password',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.red),
                      ),
                      TextSpan(
                          text: '\t We Will Send Your Reset Email',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.red))
                    ]),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _emailTextController,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Enter Email';
                      }
                      setState(() {
                        email = value;
                      });
                      return null;
                    },
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                        hintText: "Email",
                        prefixIcon: Icon(
                          Icons.email_outlined,
                        ),
                        focusedBorder: OutlineInputBorder(),
                        focusColor: Colors.green),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  FlatButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          setState(() {
                            _loading = true;
                          });

                          _authData.resetPassword(email);
                          scafflodMessage(
                              "Please Check Your ${_emailTextController.text} Email For Reset Link");
                        }
                        Navigator.pushNamed(context, LoginScreen.id);
                      },
                      color: Colors.green,
                      child: Text(
                        'Resend',
                        style: TextStyle(color: Colors.white),
                      ))
                ],
              ),
            ),
          )),
    );
  }
}
