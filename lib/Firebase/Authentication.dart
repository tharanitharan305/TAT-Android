import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:tat/Firebase/NewOrder.dart';
import 'package:tat/Screens/splashScreen.dart';
import 'package:tat/Widgets/IconGEnerae.dart';
import 'package:tat/Widgets/getAttendaceSheet.dart';

import '../Widgets/Jobs.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() {
    return _AuthenticationState();
  }
}

class _AuthenticationState extends State<Authentication> {
  final _formKey = GlobalKey<FormState>();
  var _username = '';
  var _email = '';
  var _password = '';
  var _isLogin = true;
  final _firebase = FirebaseAuth.instance;
  bool splash = false;
  Jobs jobs = Jobs.select;
  void onSubmit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      setState(() {
        splash = true;
      });
      if (!_isLogin) {
        final usercretial = await _firebase.createUserWithEmailAndPassword(
            email: _email, password: _password);
        usercretial.user!.updateDisplayName(_username);
        await FirebaseFirestore.instance
            .collection('Employees')
            .doc(_username)
            .set({
          'UserName': _username,
          'email': _email,
          "Sales": 0.0,
          "Days of Present": 0,
          "Job": jobs.name,
          "Lat": 0,
          "Long": 0
        });
        await FirebaseFirestore.instance
            .collection('Employees')
            .doc(_username)
            .collection(DateTime.now().year.toString())
            .doc(DateTime.now().month.toString())
            .set({
          'Attendance Days': AttendanceSheet()
              .getAttendanceSheet(DateTime.now().month, DateTime.now().year),
          "Mothly sales": 0.0,
          "Days of Present": 0,
          "Max sale": 0.0,
          "Max Sale Shop": "",
        });
      } else {
        final usercretial = await _firebase.signInWithEmailAndPassword(
            email: _email, password: _password);
      }
      splash = false;
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message!),
      ));
      setState(() {
        splash = false;
      });
    }
    _formKey.currentState!.save();
  }

  selectJob() {
    Get.dialog(AlertDialog(
      title: Text("Job!"),
      content: Text("Select a Job Please"),
    ));
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'images/tatlogo.png',
                width: 200,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20, top: 15, bottom: 20),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            if (!_isLogin)
                              TextFormField(
                                decoration: const InputDecoration(
                                  label: Text('Username'),
                                ),
                                validator: (value) {
                                  if (value == null ||
                                      value.isEmpty ||
                                      value.trim().length < 4) {
                                    return 'Need Atleast 4 Characters';
                                  }
                                  return null;
                                },
                                onSaved: (values) {
                                  setState(() {
                                    _username = values!;
                                  });
                                },
                              ),
                            if (!_isLogin)
                              Align(
                                alignment: Alignment.centerLeft,
                                child: DropdownButton(
                                    value: jobs,
                                    items: [
                                      ...Jobs.values
                                          .map((e) => DropdownMenuItem(
                                              key: UniqueKey(),
                                              value: e,
                                              child: Row(
                                                children: [
                                                  IconGenerate()
                                                      .GenerateJobIcon(e),
                                                  Text(e.name),
                                                ],
                                              )))
                                          .toList()
                                    ],
                                    onChanged: (value) {
                                      setState(() {
                                        jobs = value!;
                                      });
                                    }),
                              ),
                            TextFormField(
                              decoration:
                                  const InputDecoration(label: Text('Email')),
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null ||
                                    value.trim().isEmpty ||
                                    !value.contains('@')) {
                                  return 'Enter a valid email';
                                }
                                return null;
                              },
                              onSaved: (newValue) {
                                _email = newValue!;
                              },
                            ),
                            TextFormField(
                              decoration: const InputDecoration(
                                  label: Text('Password')),
                              autocorrect: false,
                              textCapitalization: TextCapitalization.none,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.length < 4) {
                                  return 'Enter a atleast 4 characters';
                                }
                                return null;
                              },
                              onSaved: (value) {
                                _password = value!;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            if (splash) SplashScreen(),
                            if (!splash)
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                                onPressed: jobs == Jobs.select && !_isLogin
                                    ? selectJob
                                    : onSubmit,
                                child: Text(_isLogin ? 'Login' : 'Sign in'),
                              ),
                            if (!splash)
                              TextButton(
                                  onPressed: () {
                                    _formKey.currentState!.reset();
                                    setState(() {
                                      _isLogin = !_isLogin;
                                    });
                                  },
                                  child: Text(_isLogin
                                      ? 'Create a account'
                                      : 'Already have a account'))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
