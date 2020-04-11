import 'package:firedeneme/login_page.dart';
import 'package:firedeneme/main_Stream.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email, _sifre;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleAuth = GoogleSignIn();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.onAuthStateChanged.listen((user) {
      if (user != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => mainStream()));
      } else
        debugPrint("Kuallanıcı giriş yapmamış");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Login Page"),
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
                      labelText: 'Mail'),
                  onSaved: (deger) => _email = deger,
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.vpn_key),
                      border: OutlineInputBorder(),
                      hintText: 'Şifrenizi giriniz',
                      labelText: 'Şifre'),
                  obscureText: true,
                  validator: (value) {
                    if (value.length < 6)
                      return 'Lütfen en az 6 karakter giriniz';
                    return null;
                  },
                  onSaved: (deger) => _sifre = deger,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton.icon(
                      color: Colors.tealAccent,
                      icon: Icon(Icons.transit_enterexit),
                      label: Text("GİRİŞ "),
                      onPressed: () {
                        _formKey.currentState.save();
                        _emailSifreLogin(_email, _sifre);
                      },
                    ),
                    RaisedButton.icon(
                      color: Colors.deepPurpleAccent,
                      icon: Icon(Icons.save),
                      label: Text("KAYDOL"),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginPage()));
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                    child: Container(
                        width:180,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30.0),
                            color: Colors.black,
                            image: DecorationImage(
                                image:AssetImage("assets/google.png"),
                                fit:BoxFit.cover
                            ),
                        )
                    ),onTap: _googleSignIn
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _emailSifreLogin(String email, String sifre) async {
    if (_formKey.currentState.validate()) {
      var firebaseUser = await _auth
          .signInWithEmailAndPassword(email: email, password: sifre)
          .catchError((hata) => debugPrint(hata));
      if (!firebaseUser.user.isEmailVerified) {
        debugPrint("Emailinizi onaylayınız");
        _auth.signOut();
      } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => mainStream()),
          (Route<dynamic> route) => false,
        );
      }
    }
  }

  void _googleSignIn() {
    _googleAuth.signIn().then((sonuc) {
      sonuc.authentication.then((googleKeys) {
        AuthCredential credential = GoogleAuthProvider.getCredential(
            idToken: googleKeys.idToken, accessToken: googleKeys.accessToken);

        _auth.signInWithCredential(credential).then((user){

          debugPrint("Google ile giriş yapıldı");


        });
      });
    }).catchError((e) => debugPrint(e));
  }
}
