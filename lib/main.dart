import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl_app/provider/language_provider.dart';

import 'package:intl_app/shared_preferences/preferencias_usuario.dart';
import 'package:intl_app/style/theme.dart';
import 'package:intl_app/widgets/widgets.dart';
import 'package:intl_app/generated/l10n.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  PreferenciasUsuario prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  LanguageProvider language = new LanguageProvider();
  await language.fetchLocale();

  runApp(App(
    language: language,
  ));
}

class App extends StatelessWidget {
  final LanguageProvider language;

  const App({
    this.language
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LanguageProvider>(create: (_) => language)
      ],
      child: Consumer<LanguageProvider>(builder: (context, language, child){
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: theme,
            locale: language.appLocale,
            home: HomePage(),
            title: 'Flutter Intl Example',
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              S.delegate
            ],
            supportedLocales: S.delegate.supportedLocales,
          );
        },
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  PreferenciasUsuario prefs = new PreferenciasUsuario();

  String _language;

  String _firstName = 'Roberto';

  String _lastName = 'Gómez';

  int _notifications = 0;

  @override
  void initState() {
    super.initState();
    _language = prefs.language;
  }

  _resetNotifications() => setState(() => _notifications = 0);

  _incrementNotifications() => setState(() => _notifications++);

  _decrementNotifications() => setState(() {
    if (_notifications > 0) _notifications--;
  });

  @override
  Widget build(BuildContext context) {
    final language = Provider.of<LanguageProvider>(context);

    return HomeScaffold(
      cards: <Widget>[
        Column(
          children: [
            RadioListTile(
              activeColor: Colors.white,
              value: "es",
              title: Text('Es', style: TextStyle(color: Colors.white),),
              groupValue: _language,
              onChanged: (value) {
                language.changeLanguage(Locale(value));
                setState(() {
                  _language = value;
                });
              },
            ),
            RadioListTile(
              activeColor: Colors.white,
              value: "en",
              title: Text('En', style: TextStyle(color: Colors.white),),
              groupValue: _language,
              onChanged: (value) {
                language.changeLanguage(Locale(value));
                setState(() {
                  _language = value;
                });
              },
            )
          ]
        ),
        TextCard(
          text: S.of(context).simpleText,
        ),
        TextCard(
          text: S.of(context).textWithPlaceholder(_firstName),
        ),
        TextCard(
          text: S.of(context).textWithPlaceholders(_firstName, _lastName),
        ),
        NotificationsCard(
          text: S.of(context).textWithPlural(_notifications),
          onReset: _resetNotifications,
          onDecrement: _decrementNotifications,
          onIncrement: _incrementNotifications,
        ),
      ],
    );
  }

}
