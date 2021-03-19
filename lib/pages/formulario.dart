import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';

class FormularioPage extends StatefulWidget {
  FormularioPage({Key key}) : super(key: key);

  @override
  _FormularioPageState createState() => _FormularioPageState();
}

class _FormularioPageState extends State<FormularioPage> {
  String qrCodeResult = "No hay codigo QR";
  String mensaje = "";
  /* String _apat = '';
  String _amat = '';
  String _nom = '';
  String _fecha = '';
  String _oficio = '';
  String _expintUAVI = ''; */
  TextEditingController _inputFieldAPaternoController =
      new TextEditingController();
  TextEditingController _inputFieldAMaternoController =
      new TextEditingController();
  TextEditingController _inputFieldNombreController =
      new TextEditingController();
  TextEditingController _inputFieldFechaController =
      new TextEditingController();
  TextEditingController _inputFieldOficioController =
      new TextEditingController();
  TextEditingController _inputFieldDuracionMedidasController =
      new TextEditingController();
  TextEditingController _inputFieldExpIntUAVIController =
      new TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [_colorFondo(), _imagenFondo(), _cuerpo(context)],
      ),
    );
  }

  Widget _colorFondo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color.fromRGBO(255, 242, 255, 1.0),
    );
  }

  Widget _imagenFondo() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Image(
        image: AssetImage('assets/images/pv_background.jpeg'),
        fit: BoxFit.cover,
      ),
    );
  }

  _limpiarFormulario() {
    _inputFieldAPaternoController.clear();
    _inputFieldAMaternoController.clear();
    _inputFieldNombreController.clear();
    _inputFieldFechaController.clear();
    _inputFieldOficioController.clear();
    _inputFieldDuracionMedidasController.clear();
    _inputFieldExpIntUAVIController.clear();
    setState(() {
      qrCodeResult = "No hay codigo QR";
      mensaje = "";
    });
  }

  Future<bool> _asistencia() async {
    //BUSCA------------------------
    final responde = await http
        .post('https://pv.parp.mx/api/victimas/victimas/crea_imei_user', body: {
      "APaterno": _inputFieldAPaternoController.text,
      "AMaterno": _inputFieldAMaternoController.text,
      "Nombre": _inputFieldNombreController.text,
      "Fecha": _inputFieldFechaController.text,
      "Oficio": _inputFieldOficioController.text,
      "DuracionMedidas": _inputFieldDuracionMedidasController.text,
      "ExpIntUAVI": _inputFieldExpIntUAVIController.text,
      "IMEI": qrCodeResult
    });

    var respuesta = json.decode(responde.body);
    print(respuesta);

    if (respuesta['status'] == true && respuesta['status_sesion'] == true) {
      //Si se creo el nuevo registro
      setState(() {
        mensaje = respuesta['msj'];
      });

      return true;
    } else {
      //Si se creo el nuevo registro
      setState(() {
        mensaje = "Ya existe este dispositivo!";
      });

      return false;
    }
  }

  Widget _cuerpo(BuildContext context) {
    final estiloTitulo = TextStyle(
        color: Colors.deepPurple, fontSize: 25.0, fontWeight: FontWeight.bold);
    final estiloTexto = TextStyle(
        color: Colors.deepPurple, fontSize: 20.0, fontWeight: FontWeight.bold);

    //String qrData = uniqueId;
    return SafeArea(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
        children: [
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Formulario de registro",
            style: estiloTitulo,
            textAlign: TextAlign.center,
          ),
          Divider(),
          _crearInput("A. Paterno", _inputFieldAPaternoController,
              Icons.filter_1_rounded),
          SizedBox(
            height: 8.0,
          ),
          _crearInput("A. Materno", _inputFieldAMaternoController,
              Icons.filter_2_rounded),
          SizedBox(
            height: 8.0,
          ),
          _crearInput(
              "Nombre", _inputFieldNombreController, Icons.filter_3_rounded),
          SizedBox(
            height: 8.0,
          ),
          _crearFecha(context),
          SizedBox(
            height: 8.0,
          ),
          _crearInput(
              "Oficio", _inputFieldOficioController, Icons.folder_shared),
          SizedBox(
            height: 8.0,
          ),
          _crearInput(
              "Duracion de medidas",
              _inputFieldDuracionMedidasController,
              Icons.folder_shared_outlined),
          SizedBox(
            height: 8.0,
          ),
          _crearInput("Expediente interno UAVI",
              _inputFieldExpIntUAVIController, Icons.folder_special),
          Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Codigo QR",
                style: TextStyle(fontSize: 16.0),
                textAlign: TextAlign.center,
              ),
              Text(
                qrCodeResult,
                style: estiloTexto,
                textAlign: TextAlign.center,
              ),
              FlatButton(
                height: 20.0,
                padding: EdgeInsets.all(20.0),
                onPressed: () async {
                  try {
                    //BarcodeScanner.scan(); //this method is used to scan the QR code
                    String codeSanner =
                        await BarcodeScanner.scan(); //barcode scnner
                    setState(() {
                      qrCodeResult = codeSanner;
                    });
                  } catch (e) {
                    //BarcodeScanner.CameraAccessDenied; //we can print that user has denied for the permisions
                    //BarcodeScanner.UserCanceled; //we can print on the page that user has cancelled
                    setState(() {
                      qrCodeResult = "No hay codigo QR";
                    });
                  }
                },
                child: Text(
                  "Scanear codigo QR",
                  style: TextStyle(
                      fontSize: 20.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                shape: RoundedRectangleBorder(
                    side:
                        BorderSide(color: Colors.deepPurpleAccent, width: 3.0),
                    borderRadius: BorderRadius.circular(20.0)),
                color: Colors.deepPurpleAccent[100],
              ),
            ],
          ),
          Divider(),
          SizedBox(
            height: 15.0,
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              children: [
                SizedBox(
                  width: 50.0,
                ),
                FlatButton(
                  height: 20.0,
                  padding: EdgeInsets.all(20.0),
                  onPressed: () async {
                    // Se procesa el formulario
                    if (_inputFieldAPaternoController.text.isNotEmpty &&
                        _inputFieldAMaternoController.text.isNotEmpty &&
                        _inputFieldNombreController.text.isNotEmpty &&
                        _inputFieldFechaController.text.isNotEmpty &&
                        _inputFieldOficioController.text.isNotEmpty &&
                        _inputFieldDuracionMedidasController.text.isNotEmpty &&
                        _inputFieldExpIntUAVIController.text.isNotEmpty &&
                        qrCodeResult.isNotEmpty &&
                        qrCodeResult != "No hay codigo QR") {
                      _asistencia();
                    } else {
                      setState(() {
                        mensaje = "Faltan datos";
                      });
                    }
                  },
                  child: Text(
                    "Guardar cambios",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.green,
                        fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.green, width: 3.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.greenAccent[100],
                ),
                SizedBox(
                  width: 60.0,
                ),
                Text(
                  mensaje,
                  style: estiloTexto,
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  width: 100.0,
                ),
                FlatButton(
                  height: 20.0,
                  padding: EdgeInsets.all(20.0),
                  onPressed: () async {
                    _limpiarFormulario();
                  },
                  child: Text(
                    "Registrar nuevo dispositivo",
                    style: TextStyle(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.blue[900], width: 3.0),
                      borderRadius: BorderRadius.circular(20.0)),
                  color: Colors.blue,
                ),
              ]),
        ],
      ),
    );
  }

  _crearFecha(BuildContext context) {
    return TextField(
      //autofocus: true,
      textCapitalization: TextCapitalization.sentences,
      controller: _inputFieldFechaController,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: 'Fecha',
          labelText: 'Fecha',
          suffixIcon: Icon(Icons.perm_contact_calendar),
          icon: Icon(Icons.calendar_today)),
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
        _selectDate(context);
      },
    );
  }

  _selectDate(BuildContext context) async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1900),
        lastDate: new DateTime(2100),
        locale: Locale('es', 'MX'));
    if (picked != null) {
      setState(() {
        _inputFieldFechaController.text = picked.toString();
      });
    }
  }

  _crearInput(
      String _nomField, TextEditingController _controlador, IconData _icono) {
    return TextField(
      //autofocus: true,
      controller: _controlador,
      textCapitalization: TextCapitalization.sentences,
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
          hintText: _nomField,
          labelText: _nomField,
          icon: Icon(_icono)),
    );
  }
}
