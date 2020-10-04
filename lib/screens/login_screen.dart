import 'package:flutter/material.dart';
import 'package:shoppingdelivery_morenope_admin/bloc/login_bloc.dart';
import 'package:shoppingdelivery_morenope_admin/screens/home_screen.dart';
import 'package:shoppingdelivery_morenope_admin/widgets/input_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _loginBloc = LoginBloc();

  @override
  void initState() {
    super.initState();
    
    _loginBloc.outState.listen((state){
      switch(state){
        case LoginState.SUCCESS:
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context)=>HomeScreen())
        );
        break;
        case LoginState.FAIL:
        showDialog(context: context, builder: (context)=>AlertDialog(
          title: Text('Erro'),
          content: Text('Você não possue os privilégios necessários!'),
        ));
        break;
        case LoginState.LOADING:
        case LoginState.IDLE:
      }
    });
  }

  @override
  void dispose(){
    _loginBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[850],
      body: StreamBuilder<LoginState>(
        stream: _loginBloc.outState,
        initialData: LoginState.LOADING,
        // ignore: missing_return
        builder: (context, snapshot) {
          switch(snapshot.data){
            case LoginState.LOADING:
            return Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue[900]),
            ),);
            case LoginState.FAIL:
            case LoginState.SUCCESS:
            case LoginState.IDLE:
            return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Container(),
              SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Icon(Icons.store, color: Colors.blue[900], size: 160),
                      Text(
                        'Shopping/Delivery\nMoreno-PE\nADMIN',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.blue[900], fontSize: 22),
                      ),
                      InputField(
                        icon: Icons.person_outline,
                        hint: 'Usuário',
                        obscure: false,
                        stream: _loginBloc.outEmail,
                        onChanged: _loginBloc.changedEmail,
                      ),
                      InputField(
                        icon: Icons.lock_outline,
                        hint: 'Senha',
                        obscure: true,
                        stream: _loginBloc.outPassword,
                        onChanged: _loginBloc.changedPassword,
                      ),
                      SizedBox(height: 18),
                      StreamBuilder<bool>(
                        stream: _loginBloc.outSubmitedValid,
                        builder: (context, snapshot) {
                          return SizedBox(
                            height: 50,
                            child: RaisedButton(
                              onPressed: snapshot.hasData ? _loginBloc.submit : null,
                              color: Colors.blue[900],
                              child: Text('Entrar', style: TextStyle(fontSize: 22),),
                              textColor: Colors.white,
                              disabledColor: Colors.blue[500],
                            ),
                          );
                        }
                      )
                    ],
                  )
                )
              ),
            ],
          );
          }
        }
      )
    );
  }
}