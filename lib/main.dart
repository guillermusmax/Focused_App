import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:focused_app/api/state_models.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/auth/loading_view.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:focused_app/generated/l10n.dart';
import 'package:focused_app/views/nav_screens/appointment/appointment_view.dart';
import 'package:focused_app/views/nav_screens/medication/medication_view.dart';
import 'package:provider/provider.dart'; // Importa Provider
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart'; // Reemplaza con flutter_timezone
import 'package:focused_app/api/timezone_service.dart'; // Import TimezoneService

/// Inicializa las zonas horarias antes de iniciar la aplicación
Future<void> initializeTimezones() async {
  try {
    // Inicializa la base de datos de zonas horarias
    tzData.initializeTimeZones();

    // Obtén la zona horaria local del dispositivo utilizando flutter_timezone
    final String localTimeZone = await FlutterTimezone.getLocalTimezone();

    // Configura la zona horaria local
    tz.setLocalLocation(tz.getLocation(localTimeZone));
    print('Zona horaria local: $localTimeZone');
  } catch (e) {
    print('Error inicializando las zonas horarias: $e');
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure the Flutter environment is ready
  tzData.initializeTimeZones(); // Inicialización única

  final TimezoneService timezoneService = TimezoneService();
  final String localTimeZone = await timezoneService.getDeviceTimeZone();
  print('Zona horaria local: $localTimeZone'); // Útil para depurar

  try {
    await dotenv.load(fileName: ".env"); // Load environment variables
    await initializeTimezones(); // Initialize timezones
  } catch (e) {
    print('Error initializing the app: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  // Este método permite acceder al estado de `MyApp`
  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Idioma predeterminado

  // Método para cambiar el idioma
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlashcardProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => MedicationState()),
        ChangeNotifierProvider(create: (_) => FlashcardCategoryState()),
        ChangeNotifierProvider(create: (_) => TaskCategoryState()),
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => FlashcardState()), // Proveedor del estado de flashcards
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Focused',
        theme: ThemeData(
          scaffoldBackgroundColor: backgroundColor,
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            iconTheme: IconThemeData(
              color: primaryColor, // Icono de hamburguesa
              size: 32.0,
            ),
          ),
        ),
        locale: _locale, // Idioma actual
        localizationsDelegates: [
          S.delegate, // Delegado generado para soportar traducciones
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales, // Locales soportados
        home: const LoadingView(),
        routes: {
          '/appointments': (context) => const AppointmentView(),
          '/medications': (context) => const MedicationView(),
        },
      ),
    );
  }
}
