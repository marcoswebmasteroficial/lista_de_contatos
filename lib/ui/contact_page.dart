import 'dart:io';
import 'package:contatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _FocusName = FocusNode();
  bool _UserEdit = false;
  Contact _editedContact;

  @override
  void initState() {
    super.initState();
    if (widget.contact == null) {
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());
      _nameController.text = _editedContact.name;
      _emailController.text = _editedContact.email;
      _phoneController.text = _editedContact.phone;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          title: Text(_editedContact.name ?? "Novo Contato"),
          centerTitle: true,
          backgroundColor: Colors.pink,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (_editedContact.name != null && _editedContact.name.isNotEmpty) {
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_FocusName);
            }
          },
          backgroundColor: Colors.pink,
          child: Icon(Icons.save),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {

                    ImagePicker.pickImage(source: ImageSource.gallery)
                        .then((file) {
                      if (file == null) return;

                      setState(() {
                        _editedContact.img = file.path;
                      });
                    });
                  },
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: _editedContact.img != null
                                ? FileImage(File(_editedContact.img))
                                : AssetImage("images/default.png"),
                            fit: BoxFit.cover)),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _FocusName,
                  decoration: InputDecoration(
                    labelText: "Nome",
                    labelStyle: TextStyle(color: Colors.pink),
                    border: OutlineInputBorder(),
                    filled: true,
                    contentPadding: EdgeInsets.only(bottom: 30.0, left: 30.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.pink, width: 3.0)),
                  ),
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  onChanged: (text) {
                    _UserEdit = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: "E-mail",
                    labelStyle: TextStyle(color: Colors.pink),
                    border: OutlineInputBorder(),
                    filled: true,
                    contentPadding: EdgeInsets.only(bottom: 30.0, left: 30.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.pink, width: 3.0)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  onChanged: (text) {
                    _UserEdit = true;
                    _editedContact.email = text;
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                    labelText: "Phone",
                    labelStyle: TextStyle(color: Colors.pink),
                    border: OutlineInputBorder(),
                    filled: true,
                    contentPadding: EdgeInsets.only(bottom: 30.0, left: 30.0),
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        borderSide: BorderSide(color: Colors.pink, width: 3.0)),
                  ),
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Colors.black, fontSize: 18.0),
                  onChanged: (text) {
                    _UserEdit = true;
                    _editedContact.phone = text;
                  },
                )
              ],
            )),
      ),
    );
  }

  Future<bool> _requestPop() {
    if (_UserEdit) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Descartar Alterações?"),
              content: Text("Se sair as alterações serão Perdidas"),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  child: Text('Sim'),
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancelar'),
                )
              ],
            );
          });
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}
