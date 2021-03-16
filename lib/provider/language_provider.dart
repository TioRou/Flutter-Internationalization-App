import 'package:flutter/material.dart';
import 'package:intl_app/shared_preferences/preferencias_usuario.dart';

class LanguageProvider extends ChangeNotifier {
  Locale _appLocale = Locale('es');

  Locale get appLocale => _appLocale ?? Locale("es");

  PreferenciasUsuario prefs = new PreferenciasUsuario();

  fetchLocale()  {
    _appLocale = Locale(prefs.language);
  }


  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }
    if (type == Locale("en")) {
      _appLocale = Locale("en");
      prefs.language = "en";
    } else {
      _appLocale = Locale("es");
      prefs.language = "es";
    }
    notifyListeners();
  }
}