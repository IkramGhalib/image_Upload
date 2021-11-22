import 'package:flutter/material.dart';
import 'package:grocery_vendor/provider/auth_provider.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/screens/register_screen.dart';
import 'package:grocery_vendor/screens/resetPassword_screen.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static const String id = 'login';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _emailTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  String email;
  String password;
  bool _isLoading = false;
  Icon icon;
  bool _visible = true;
  @override
  Widget build(BuildContext context) {
    final _authData = Provider.of<AuthProvider>(context);
    return Scaffold(
       body: Form(
         key: _formKey,
         child: Padding(
              padding: EdgeInsets.all(10),
              child: ListView(
                children: <Widget>[
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'BCHEDO',
                        style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: 30),
                      )),
                  Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(10),
                      child: Text(
                        'Sign in',
                        style: TextStyle(fontSize: 20),
                      )),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
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
                        border: OutlineInputBorder(),
                        labelText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    child: TextFormField(
                       controller: _passwordTextController,
                          validator: (value) {
                            if (value.length < 6) {
                              return 'Minimum 6 charcter';
                            }
                            if (value.isEmpty) {
                              return 'Please Enter Password';
                            }
                            setState(() {
                              password = value;
                            });
                            return null;
                          },
                          obscureText: _visible,
                      decoration: InputDecoration(
                         suffix: IconButton(
                                icon: _visible
                                    ? Icon(Icons.visibility)
                                    : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _visible = !_visible;
                                  });
                                },
                              ),
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: (){
                      //forgot password screen
                      Navigator.pushNamed(context, ResetPassword.id);
                    },
                    textColor: Colors.blue,
                    child: Text('Forgot Password'),
                  ),
                  Container(
                    height: 50,
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: RaisedButton(
                        textColor: Colors.white,
                        color: Colors.green,
                        child: Text('Login'),
                        onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _authData
                                        .loginVendor(email, password)
                                        .then((credential) {
                                      if (credential != null) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Navigator.pushNamed(context, HomeScreen.id);
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(_authData.error)));
                                  }
                        },
                      )),
                  Container(
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Colors.red,
                          child: Text(
                            'Register',
                            style: TextStyle(fontSize: 18),
                          ),
                          onPressed: () {
                            //signup screen
                            Navigator.pushNamed(context, RegisterScreen.id);
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                  ))
                ],
              )),
       ));
  }
}