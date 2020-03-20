import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:contatos/helpers/contact_helper.dart';
import 'contact_page.dart';

enum OrdemOptions { orderaz, ordemza }

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

/*  helper.clear();*/
/*Contact c = Contact();
c.name ="Marcos";
c.email ="marcoswebmaster@hotmail.com";
c.phone ="66587444";
c.img = "";
helper.saveContact(c);*/
    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        centerTitle: true,
        backgroundColor: Colors.pink,
        actions: <Widget>[
          PopupMenuButton<OrdemOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrdemOptions>>[
              const PopupMenuItem<OrdemOptions>(
                child: Text("Ordernar A-Z"),
                value: OrdemOptions.orderaz,
              ),
              const PopupMenuItem<OrdemOptions>(
                child: Text("Ordernar Z-A"),
                value: OrdemOptions.ordemza,
              )
            ],onSelected: _orderList,
          )
        ],
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _ContactCard(context, index);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _ShowContactPage();
        },
        backgroundColor: Colors.pink,
        child: Icon(Icons.add),
      ),
    );
  }

  void _ShowOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            onClosing: () {},
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          launch("tel:${contacts[index].phone}");
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Ligar",
                          style: TextStyle(color: Colors.pink, fontSize: 20.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _ShowContactPage(contact: contacts[index]);
                        },
                        child: Text(
                          "Editar",
                          style: TextStyle(color: Colors.pink, fontSize: 20.0),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: FlatButton(
                        onPressed: () {
                          setState(() {
                            helper.deleteContact(contacts[index].id);
                            contacts.removeAt(index);
                            Navigator.pop(context);
                          });
                        },
                        child: Text(
                          "Excluir",
                          style: TextStyle(color: Colors.pink, fontSize: 20.0),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          );
        });
  }

  Widget _ContactCard(BuildContext context, int index) {
    return GestureDetector(
      child: Card(
        child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Row(
              children: <Widget>[
                Container(
                  width: 80.0,
                  height: 80.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: contacts[index].img != null
                              ? FileImage(File(contacts[index].img))
                              : AssetImage("images/default.png"),
                          fit: BoxFit.cover)),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(contacts[index].name ?? "",
                          style: TextStyle(
                              fontSize: 22.0, fontWeight: FontWeight.bold)),
                      Text(contacts[index].email ?? "",
                          style: TextStyle(fontSize: 18.0)),
                      Text(contacts[index].phone ?? "",
                          style: TextStyle(fontSize: 18.0)),
                    ],
                  ),
                )
              ],
            )),
      ),
      onTap: () {
        _ShowOptions(context, index);
      },
    );
  }

  void _ShowContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact)));

    if (recContact != null) {
      if (contact != null) {
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      print(list);
      setState(() {
        contacts = list;
      });
    });
  }
  void _orderList(OrdemOptions result){
    switch(result) {
      case OrdemOptions.orderaz:
          contacts.sort((a, b) {
            return  a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrdemOptions.ordemza:
        contacts.sort((a, b) {
          return   b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }
}
