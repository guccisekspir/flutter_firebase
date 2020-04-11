import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class mainStream extends StatefulWidget {
  @override
  _mainStreamState createState() => _mainStreamState();
}

class _mainStreamState extends State<mainStream> {
  final Firestore _fireStore = Firestore.instance;
  final _formKey = GlobalKey<FormState>();
  int gidecekPara = 0, mevcutPara = 0;
  String gucciBan = "";
  bool varMi;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore"),
      ),
      body: Center(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Yatırılacak Tutarı Giriniz",
                      labelText: "Transfer Tutarı"),
                  validator: _gidecekParaValidator,
                  onSaved: (deger) => gidecekPara = int.parse(deger),
                ),
                SizedBox(
                  height: 8.0,
                ),
                RaisedButton(
                  child: Text("Eft Yap"),
                  onPressed: _eftYap,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> gucciEkle = Map();
    gucciEkle["ad"] = "Çağrı";
    gucciEkle["emailOnay"] = true;
    _fireStore
        .collection("users")
        .document("gucciSekspir")
        .setData(gucciEkle,
            merge:
                true) //Merge üstüne yazmıyor varolanlar kalıyor yeniler ekleniyor
        .then((v) => debugPrint("Gucci EKelendi"));

    _fireStore.document("/users/ayse").setData({'ad': 'ayşe'});
    _fireStore.collection("users").add({'ad': 'deneme'});
    String newUserId = _fireStore.collection("users").document().documentID;
    _fireStore.document("users/$newUserId").setData({'ad': 'gucciyeni'});
  }

  void _transactionEkle() {}

  Future<void> _eftYap() async {
    DocumentSnapshot documentSnapshot =
        await _fireStore.document("users/123456").get();
    mevcutPara = documentSnapshot.data['bakiye'];




    _formKey.currentState.validate();
  }

  String _gidecekParaValidator(String value) {
    if (mevcutPara < int.parse(value))
      return "Paranız yetmemekte";
    else
      return null;
  }


}
