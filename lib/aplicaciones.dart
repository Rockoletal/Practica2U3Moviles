
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'package:dam_u3_practica2_reservaciones/BaseDatos.dart';







class AppReservacion extends StatefulWidget {
  const AppReservacion({super.key});

  @override
  State<AppReservacion> createState() => _AppReservacionState();
}

class _AppReservacionState extends State<AppReservacion> {
  @override
  String titulo = "RESTAURANTE CAMS";
  int _index = 0;
  String id = "";

  final nombreReservacion = TextEditingController();
  final fechaReservacion = TextEditingController();
  final horaReservacion = TextEditingController();
  final telefonoReservacion = TextEditingController();
  final numeroPersonas = TextEditingController();

  final UnombreReservacion = TextEditingController();
  final UfechaReservacion = TextEditingController();
  final UhoraReservacion = TextEditingController();
  final UtelefonoReservacion = TextEditingController();
  final UnumeroPersonas = TextEditingController();



  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        centerTitle: true,
      ),

      body: dinamico(),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 40,
                  child: Image(
                    image: AssetImage("assets/cyt2.png"),
                    height: 45,
                  ),
                ),
                SizedBox(height: 20,),
                Text("Restaurante CAMS", style: TextStyle(color: Colors.white, fontSize: 20),)
              ],
            ),
              decoration: BoxDecoration(color: Colors.orangeAccent),
            ),
            _item(Icons.add, "Insertar Reservacion", 1),
            _item(Icons.checklist_outlined, "Reservaciones del dia", 2),
            _item(Icons.format_list_bulleted, "Lista de Reservados", 0),
            //_item(Icons.info, "Acerca De", 3),
          ],
        ),
      ),

    );
  }

  Widget _item(IconData icono, String texto, int indice) {
    return ListTile(
      onTap: (){
        setState(() {
          _index = indice;
        });
        Navigator.pop(context);
      },
      title: Row(
        children: [Expanded(child: Icon(icono)), Expanded(child: Text(texto),flex: 2,)],
      ),
    );
  }


  Widget dinamico(){
    if(_index==1){
      return insertar();
    }
    if(_index==2){
      return mostrardia();
    }
    //if(_index==3){
    //  return acerde();
    //}
    return mostrar();
  }

  Widget acerde(){
    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        Text("Es una app de Reservaciones basada en un restaurante, Donde podemos insertar las reservaciones, Ver las reservaciones del dia actual y ver las reservaciones anteriores o posteriores. Algunos campos como el de telefono solo acepta 10 digitos para poder ser insertados", textAlign: TextAlign.center, style: TextStyle(fontSize: 18),),
      ],
    );
  }


  Widget insertar() {

    return ListView(
      padding: EdgeInsets.all(40),
      children: [
        TextField(
          controller: nombreReservacion,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Nombre',
            suffixIcon: Icon(Icons.person),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: fechaReservacion,
          readOnly: true,
          onTap: () async {
            var _selectedDate = await getDatePickerWidget();
            if (_selectedDate != null) {
              _currentSelectedDate = _selectedDate;
              fechaReservacion.text =
              "${_currentSelectedDate!.day}/${_currentSelectedDate!.month}/${_currentSelectedDate!.year}";
            }
          },
          decoration: InputDecoration(
            labelText: 'Seleccionar fecha',
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: horaReservacion,
          readOnly: true,
          onTap: () async {
            var _selectedTime = await getTimePickerWidget();
            if (_selectedTime != null) {
              _currentTime = _selectedTime;
              horaReservacion.text =
              "${_currentTime!.hour}:${_currentTime!.minute}";
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Hora',
            suffixIcon: Icon(Icons.access_time),
          ),
        ),
        SizedBox(height: 20),
        TextField(
          controller: telefonoReservacion,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Teléfono',
            suffixIcon: Icon(Icons.phone),
            counterText: '',
          ),
          keyboardType: TextInputType.phone,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          maxLength: 10,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
        ),
        SizedBox(height: 20),
        TextField(
          controller: numeroPersonas,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'Número de Personas',
            suffixIcon: Icon(Icons.people),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (input) {
            if (!validarNumeroPersonas(input)) {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Número máximo alcanzado"),
                    content: Text("El número máximo de personas es 10."),
                    actions: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text("OK"),
                      ),
                    ],
                  );
                },
              );
              //
              numeroPersonas.text = '';
            }
          },
        ),
        SizedBox(height: 30),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            ElevatedButton(
              onPressed: () {
                var JSonTemporal = {
                  'nombre': nombreReservacion.text,
                  'fechaReservacion': fechaReservacion.text,
                  'horaReservacion': horaReservacion.text,
                  'telefono': int.parse(telefonoReservacion.text),
                  'numeroPersonas': int.parse(numeroPersonas.text),
                };

                BD.insertar(JSonTemporal).then((value) {
                  setState(() {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Se inserto...")));
                  });
                });

                nombreReservacion.text = "";
                fechaReservacion.text = "";
                horaReservacion.text = "";
                telefonoReservacion.text = "";
                numeroPersonas.text = "";


              },
              child: Text("Insertar"),
            ),
            Container(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _index = 0;
                });
              },
              child: Text("Cancelar"),
            ),
          ],
        )
      ],
    );
  }


  void actualizar() {


    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (builder) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
              top: 20,
              left: 20,
              right: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              children: [
                TextField(
                  controller: UnombreReservacion,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Nombre',
                    suffixIcon: Icon(Icons.person),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: UfechaReservacion,
                  readOnly: true,
                  onTap: () async {
                    var _selectedDate = await getDatePickerWidget();
                    if (_selectedDate != null) {
                      _currentSelectedDate = _selectedDate;
                      UfechaReservacion.text =
                      "${_currentSelectedDate!.day}/${_currentSelectedDate!.month}/${_currentSelectedDate!.year}";
                    }
                  },
                  decoration: InputDecoration(
                    labelText: 'Seleccionar fecha',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.calendar_today),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: UhoraReservacion,
                  readOnly: true,
                  onTap: () async {
                    var _selectedTime = await getTimePickerWidget();
                    if (_selectedTime != null) {
                      _currentTime = _selectedTime;
                      horaReservacion.text =
                      "${_currentTime!.hour}:${_currentTime!.minute}";
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Hora',
                    suffixIcon: Icon(Icons.access_time),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: UtelefonoReservacion,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Teléfono',
                    suffixIcon: Icon(Icons.phone),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                ),
                SizedBox(height: 20),
                TextField(
                  controller: UnumeroPersonas,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Número de Personas',
                    suffixIcon: Icon(Icons.people),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        var JSonTemporal = {
                          'nombre': UnombreReservacion.text,
                          'fechaReservacion': UfechaReservacion.text,
                          'horaReservacion':UhoraReservacion.text,
                          'telefono': int.parse(UtelefonoReservacion.text),
                          'numeroPersonas': int.parse(UnumeroPersonas.text),
                          'id': id,
                        };
                        BD.update(JSonTemporal).then((value) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Se actualizo...")));
                          });
                        });
                        UnombreReservacion.text = "";
                        UfechaReservacion.text = "";
                        UhoraReservacion.text = "";
                        UtelefonoReservacion.text = "";
                        UnumeroPersonas.text = "";
                        Navigator.pop(context);
                      },
                      child: Text("Actualizar"),
                    ),

                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget mostrar() {
    return FutureBuilder(
      future: BD.mostrar(),
      builder: (context, listaJSON) {
        if (listaJSON.hasData) {
          return ListView.builder(
            itemCount: listaJSON.data?.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    listaJSON.data![index]['nombre'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha de Reservación: ${listaJSON.data![index]['fechaReservacion']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Hora de Reservación: ${listaJSON.data![index]['horaReservacion']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Teléfono: ${listaJSON.data![index]['telefono']}',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        BD.eliminar(listaJSON.data![index]['id']);
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      UnombreReservacion.text = listaJSON.data![index]['nombre'];
                      UfechaReservacion.text = listaJSON.data![index]['fechaReservacion'];
                      UhoraReservacion.text = listaJSON.data![index]['horaReservacion'];
                      UtelefonoReservacion.text = listaJSON.data![index]['telefono'].toString();
                      UnumeroPersonas.text = listaJSON.data![index]['numeroPersonas'].toString();
                      id = listaJSON.data![index]['id'];
                    });
                    actualizar();

                  },

                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget mostrardia() {
    return FutureBuilder(
      future: BD.mostrardia(),
      builder: (context, listaJSON) {
        if (listaJSON.hasData) {
          return ListView.builder(
            itemCount: listaJSON.data?.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 5,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(
                    listaJSON.data![index]['nombre'],
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Fecha de Reservación: ${listaJSON.data![index]['fechaReservacion']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Hora de Reservación: ${listaJSON.data![index]['horaReservacion']}',
                        style: TextStyle(fontSize: 16),
                      ),
                      Text(
                        'Teléfono: ${listaJSON.data![index]['telefono']}',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        BD.eliminar(listaJSON.data![index]['id']);
                      });
                    },
                  ),
                  onTap: () {
                    setState(() {
                      UnombreReservacion.text = listaJSON.data![index]['nombre'];
                      UfechaReservacion.text = listaJSON.data![index]['fechaReservacion'];
                      UhoraReservacion.text = listaJSON.data![index]['horaReservacion'];
                      UtelefonoReservacion.text = listaJSON.data![index]['telefono'].toString();
                      UnumeroPersonas.text = listaJSON.data![index]['numeroPersonas'].toString();
                      id = listaJSON.data![index]['id'];
                    });
                    actualizar();

                  },

                ),
              );
            },
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }






//FECHA
  void callDatePicker() async{
    var selectedDate = await getDatePickerWidget();
    setState(() {
      _currentSelectedDate = selectedDate;
    });
  }

  var _currentSelectedDate;

  Future <DateTime?> getDatePickerWidget() {
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orangeAccent,
              onPrimary: Colors.white,
              onSurface: Colors.orangeAccent,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orangeAccent, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
//TIEMPO
  void callTimePicker() async{
    var selectedTime = await getTimePickerWidget();
    setState(() {
      _currentTime = selectedTime!;
    });
  }

  var _currentTime = TimeOfDay.now();

  Future <TimeOfDay?> getTimePickerWidget() {
    return showTimePicker(
      context: context,
      initialTime: _currentTime,

      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.orangeAccent,
              onPrimary: Colors.white,
              onSurface: Colors.orangeAccent,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orangeAccent, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }

  bool validarNumeroPersonas(String input) {
    int? numero = int.tryParse(input);
    return numero != null && numero <= 10;
  }


}


