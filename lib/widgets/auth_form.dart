import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat/widgets/user_image_picker.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({
    Key? key,
    required this.submitFn,
    required this.isLoading,
  }) : super(key: key);
  final Future<void> Function(
      {required BuildContext ctx,
      required String email,
      required bool isLogin,
      required String password,
      required String username,
      required File userImage}) submitFn;
  final bool isLoading;

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  var _username, _email, _password, _userImage;

  void pickedImageFn(File Image) {
    setState(() {
      _userImage = Image;
    });
  }

  _onSubmit() {
    if (_userImage == null && !_isLogin) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please click a picture'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (kDebugMode) {
        if (_isLogin) {}
        widget.submitFn(
          email: _email,
          password: _password,
          username: _username ?? '',
          isLogin: _isLogin,
          ctx: context,
          userImage: _isLogin ? File('') : _userImage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: const EdgeInsets.all(20.0),
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!_isLogin)
                    UserImagePicker(
                      imageFn: pickedImageFn,
                    ),
                  TextFormField(
                    key: const ValueKey('email'),
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: 'Email address',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || !value.contains('@')) {
                        return 'Please enter a valid email address';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _email = value!.trim();
                    },
                  ),
                  if (!_isLogin)
                    TextFormField(
                      key: const ValueKey('username'),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.all(8.0),
                        labelText: 'Username',
                      ),
                      validator: (value) {
                        if (value!.isEmpty || (value.length < 4)) {
                          return 'Username must have at least 4 characters';
                        } else {
                          return null;
                        }
                      },
                      onSaved: (value) {
                        _username = value!.trim();
                      },
                    ),
                  TextFormField(
                    key: const ValueKey('password'),
                    obscureText: true,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.all(8.0),
                      labelText: 'Password',
                    ),
                    validator: (value) {
                      if (value!.isEmpty || (value.length < 7)) {
                        return 'Username must have at least 6 characters';
                      } else {
                        return null;
                      }
                    },
                    onSaved: (value) {
                      _password = value!.trim();
                    },
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  widget.isLoading
                      ? const CircularProgressIndicator()
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              onPressed: _onSubmit,
                              child: Text(_isLogin ? 'Login' : 'Signup'),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _isLogin = !_isLogin;
                                });
                              },
                              child: Text(_isLogin
                                  ? 'Create new account?'
                                  : 'I am already having an account'),
                            ),
                          ],
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
