import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() {
    return _AuthenticationState();
  }
}

class _AuthenticationState extends State<Authentication> {
  final _formKey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _isLogin = true;
  final _firebase = FirebaseAuth.instance;
  void onSubmit() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) return;
    try {
      if (!_isLogin) {
        final usercretial = await _firebase.createUserWithEmailAndPassword(
            email: _email, password: _password);
      } else {
        final usercretial = await _firebase.signInWithEmailAndPassword(
            email: _email, password: _password);
      }
    } on FirebaseAuthException catch (error) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.message!),
      ));
    }
    _formKey.currentState!.save();
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'images/tatlogo.png',
                width: 200,
              ),
              Card(
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
                            decoration:
                                const InputDecoration(label: Text('Password')),
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
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            onPressed: onSubmit,
                            child: Text(_isLogin ? 'Login' : 'Sign in'),
                          ),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
