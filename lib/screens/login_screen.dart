import 'package:flutter/material.dart';
import 'package:grocery_vendor/provider/auth_provider.dart';
import 'package:grocery_vendor/screens/home_screen.dart';
import 'package:grocery_vendor/screens/resetPassword_screen.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login-screen';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
    return SafeArea(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            "images/welcome.png",height: 70,
                          
                          )
                        ],
                      ),
                      SizedBox(height: 40,),
                      Row(
                        children:[
                        Expanded(
                            
                            child: TextButton(onPressed: () { 
                              Navigator.pushNamed(context, ResetPassword.id);
                             }, child: Text('Forgot Password?',
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                          
                          
                          )
                        ]
            
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
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
                              enabledBorder: OutlineInputBorder(),
                              contentPadding: EdgeInsets.zero,
                              hintText: "Email",
                              prefixIcon: Icon(
                                Icons.email_outlined,
                              ),
                              focusedBorder: OutlineInputBorder(),
                              focusColor: Colors.green),
                        ),
                      ),
            
                      // password
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
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
                          keyboardType: TextInputType.text,
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
                              enabledBorder: OutlineInputBorder(),
                              contentPadding: EdgeInsets.zero,
                              hintText: "Password",
                              prefixIcon: Icon(Icons.vpn_key_outlined),
                              focusedBorder: OutlineInputBorder(),
                              focusColor: Colors.green),
                        ),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: FlatButton(
                                color: Colors.green,
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      _isLoading = false;
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
                                child: _isLoading
                                    ? LinearProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                        backgroundColor: Colors.transparent,
                                      )
                                    : Text(
                                        "Login",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
            ),
            
          ),
        ),
      ),
    );
  }
}
