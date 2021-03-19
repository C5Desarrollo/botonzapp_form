import 'package:flutter/material.dart';
import 'package:botonzapp_form/pages/formulario.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('es', 'MX'), // Español
        ],
        title: 'Pulso de Vida',
        initialRoute: 'form',
        routes: {
          'form': (BuildContext context) => FormularioPage(),
        },
        theme: ThemeData(
          primaryColor: Colors.deepPurple,
        ));
  }
}
