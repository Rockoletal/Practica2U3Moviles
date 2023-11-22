import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

var db = FirebaseFirestore.instance;

class BD {

  static Future insertar(Map<String, dynamic> datos) async {
    return await db.collection("reservacion").add(datos);
  }

  static Future eliminar(String id) async {
    return await db.collection("reservacion").doc(id).delete();
  }

  static Future update( Map<String, dynamic> datos) async {
    String id = datos["id"];
    datos.remove(id);
    return await db.collection("reservacion").doc(id).update(datos);
  }

  static Future <List> mostrar() async {
    List temp = [];
    var query = await db.collection("reservacion").get();

    query.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id': element.id
      });
      temp.add(dato);
    });
    return temp;
  }



  static Future <List> mostrardia() async {
    List temp = [];
    DateTime hoy = DateTime.now();
    String formato = DateFormat("dd/MM/yyyy").format(hoy);

    var query = await db.collection("reservacion").where("fechaReservacion", isEqualTo: formato).get();

    query.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id': element.id
      });
      temp.add(dato);
    });
    return temp;
  }





}
