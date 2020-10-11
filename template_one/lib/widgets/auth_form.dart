import 'package:flutter/material.dart';
import 'package:template_one/models/auth_data.dart';

class AuthForm extends StatefulWidget {
  final void Function(AuthData authData) onSubmit;

  AuthForm(this.onSubmit);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final AuthData _authData = AuthData();

  _submit() {
    bool isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      widget.onSubmit(_authData);
    }
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('ou'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget _signInButton() {
    return OutlineButton(
      splashColor: Colors.grey,
      onPressed: () {},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
                image: AssetImage("assets/images/google_logo.png"),
                height: 35.0),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                'Logar com o Google',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(20),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (_authData.isSignup)
                  TextFormField(
                    key: ValueKey('name'),
                    decoration: InputDecoration(
                      labelText: 'Nome',
                    ),
                    initialValue: _authData.name,
                    onChanged: (value) => _authData.name = value,
                    validator: (value) {
                      if (value == null || value.trim().length < 4) {
                        return 'Nome deve ter no mínimo 4 caracteres';
                      }
                      return null;
                    },
                  ),
                TextFormField(
                  key: ValueKey('email'),
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                  ),
                  onChanged: (value) => _authData.email = value,
                  validator: (value) {
                    //aplicar regex para melhorar
                    if (value == null || !value.contains('@')) {
                      return 'Forneça um e-mail válido';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  key: ValueKey('password'),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                  ),
                  onChanged: (value) => _authData.password = value,
                  validator: (value) {
                    if (value == null || value.trim().length < 7) {
                      return 'Senha deve ter no mínimo 7 caracteres';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                RaisedButton(
                  child: Text(_authData.isLogin ? 'Entrar' : 'Cadastrar'),
                  onPressed: _submit,
                ),
                if (_authData.isLogin) _divider(),
                if (_authData.isLogin) _signInButton(),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text(
                    _authData.isLogin
                        ? 'Criar uma nova conta ?'
                        : 'Já possui uma conta ?',
                  ),
                  onPressed: () {
                    setState(() {
                      _authData.toggleMode();
                    });
                  },
                )
              ],
            )),
      ),
    );
  }
}
