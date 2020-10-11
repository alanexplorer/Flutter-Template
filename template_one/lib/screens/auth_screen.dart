import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:template_one/models/auth_data.dart';
import 'package:template_one/widgets/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:template_one/widgets/wave_clipper.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _isLoading = false;

  Future<void> _handleSubmit(AuthData authData) async {
    setState(() {
      _isLoading = true;
    });

    UserCredential authResult;

    try {
      if (authData.isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
          email: authData.email.trim(),
          password: authData.password,
        );
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
          email: authData.email.trim(),
          password: authData.password,
        );
        final userData = {
          'name': authData.name,
          'email': authData.email,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(authResult.user.uid)
            .set(userData);
      }
    } on FirebaseAuthException catch (err) {
      final msg = err.message ?? 'Ocorreu um erro! Verifique suas credenciais';
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
    } catch (err) {
      print(err);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      key: _scaffoldKey,
      body: Container(
        child: Stack(
          children: <Widget>[
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                color: Colors.lightBlue,
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: new Image.asset(
                  "assets/images/logo.png",
                  height: 250.0,
                  width: 250.0,
                  fit: BoxFit.scaleDown,
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      AuthForm(_handleSubmit),
                      if (_isLoading)
                        Positioned.fill(
                          child: Container(
                            margin: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
