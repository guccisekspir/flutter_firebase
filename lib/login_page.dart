import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  String _email,_sifre;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Sign In Page"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(

              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.account_circle),
                    border: OutlineInputBorder(),
                    hintText: 'Mailinizi Giriniz',
                    labelText: 'Mail'
                  ),
                  validator: _emailKontrol,
                  onSaved: (deger)=> _email=deger ,

                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(),
                      hintText: 'Şifrenizi giriniz',
                    labelText: 'Şifre'
                  ),
                  obscureText: true,
                  validator: (value){
                    if(value.length<6) return 'Lütfen en az 6 karakter giriniz';
                    return null;
                  },
                  onSaved: (deger) => _sifre=deger,

                ),
                RaisedButton.icon(
                  icon: Icon(Icons.save),
                  label: Text("KAYDET"),
                  onPressed: (){
                    _formKey.currentState.save();
                    _emailSifreLogin(_email, _sifre);

                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _emailSifreLogin(String mail, String sifre) async {

    if(_formKey.currentState.validate()){
      var firebaseUser = await _auth.createUserWithEmailAndPassword(
          email: mail, password: sifre).catchError((e) =>
          debugPrint("Hata" + e.toString()));


      if(firebaseUser!= null){
        debugPrint("uid"+ firebaseUser.user.uid.toString());
        debugPrint(firebaseUser.user.isEmailVerified.toString());
        firebaseUser.user.sendEmailVerification().then((data) => _auth.signOut()).catchError((e)=> debugPrint(e));
      }
    }
  }

  String _emailKontrol(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Mail adresinizi doğru giriniz';
    else
      return null;
  }
}
