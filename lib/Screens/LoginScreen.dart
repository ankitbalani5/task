import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:task/Constant.dart';
import 'package:http/http.dart' as http;
import 'package:task/Model/LoginModel.dart';

import 'SchemeScreen.dart';

class Loginscreen extends StatefulWidget {
  const Loginscreen({super.key});

  @override
  State<Loginscreen> createState() => _LoginscreenState();
}

class _LoginscreenState extends State<Loginscreen> {

  var _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';
  bool remenberMe = false;
  bool isObscure = true;
  bool loginLoading = false;

  @override
  void initState() {

    super.initState();
  }

  Future<void> _login() async {
    try {
      loginLoading = true;
      setState(() {

      });
      final response = await http.post(
        Uri.parse('https://test.bookinggksm.com/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
          'user_type': '4',
          'device_token': Constant.fcmToken,
        }),
      );

      // Check if the response is successful
      if (response.statusCode == 200) {
        final data = LoginModel.fromJson(jsonDecode(response.body));

        if (data.status == true) {
          setState(() {

          });
          await FirebaseMessaging.instance.subscribeToTopic('task2');
          loginLoading = false;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SchemeScreen()),
          );
          Constant.token = data.token;
          print('token::::::${Constant.token}');
        } else {
          loginLoading = false;

          setState(() {
            _errorMessage = data.message ?? 'Login failed';
            Fluttertoast.showToast(msg: _errorMessage);
          });
        }
      } else {

        loginLoading = false;

        setState(() {
          _errorMessage = 'Error: ${response.statusCode} - ${response.body}';
          Fluttertoast.showToast(msg: _errorMessage);
        });
      }
    } catch (e) {

      setState(() {
        _errorMessage = 'Network error: $e';
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 80,),
                Text('Login in Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25, color: Constant.bgText),),
                SizedBox(height: 20,),
                Text('Please login to continue using our app', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14, color: Constant.bgGrey)),
                SizedBox(height: 40,),

                Container(
                  height: 55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Constant.bgText, width: 1.5),
                  ),

                    child: const Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text('Associate', style: TextStyle(color: Constant.bgText, fontWeight: FontWeight.bold, fontSize: 16),),
                        ),
                      ],
                    )
                ),
                SizedBox(height: 20,),

                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: TextStyle(color: Constant.bgText),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide(width: 1.5, color: Constant.bgText)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(width: 1.5, color: Constant.bgText)
                    ),
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter email';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                TextFormField(
                  obscureText: isObscure,
                  controller: _passwordController,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: TextStyle(color: Constant.bgText),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(width: 1.5, color: Constant.bgText)
                      ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(width: 1.5, color: Constant.bgText)
                    ),
                    suffixIcon: GestureDetector(
                        onTap: () {
                          isObscure = !isObscure;
                          setState(() {

                          });
                        },
                        child: Icon(isObscure ? Icons.remove_red_eye : Icons.visibility_off, size: 20,))
                  ),
                  validator: (value) {
                    if(value == null || value.isEmpty){
                      return 'Please enter email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    Checkbox(
                      value: remenberMe,
                      onChanged: (value) {
                        remenberMe = value!;
                        setState(() {

                        });
                    },),
                    Text('Remember Me')
                  ],
                ),

                SizedBox(height: 20,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Forgot Password', style: TextStyle(fontWeight: FontWeight.bold, color: Constant.bgText),)
                  ],
                )

              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        height: 120,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                if(_formKey.currentState!.validate()){
                  _login();
                }
              },
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Constant.bgText,

                ),
                child: Center(
                    child: loginLoading ? CircularProgressIndicator(color: Colors.white,) :
                Text('Login', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),)),
              ),
            ),
            SizedBox(height: 10,),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ", style: TextStyle(fontWeight: FontWeight.w500)),
                Text("Sign Up", style: TextStyle(fontWeight: FontWeight.bold, color: Constant.bgText)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
