import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tzData;
import 'package:timezone/timezone.dart' as tz;

class TimezoneService {
  // Inicializa las zonas horarias y configura la localización
  Future<void> initializeTimezones() async {
    try {
      tzData.initializeTimeZones();

      // Obtén la zona horaria del dispositivo
      final String localTimeZone = await getDeviceTimeZone();

      // Configura la zona horaria local
      tz.setLocalLocation(tz.getLocation(localTimeZone));
      print('Zona horaria inicializada: $localTimeZone');
    } catch (e) {
      print('Error al inicializar las zonas horarias: $e');
    }
  }

  // Obtiene la zona horaria del dispositivo
  Future<String> getDeviceTimeZone() async {
    try {
      final timezone = await FlutterTimezone.getLocalTimezone();
      return timezone;
    } catch (e) {
      print('Error al obtener la zona horaria: $e');
      return 'UTC'; // Valor predeterminado en caso de error
    }
  }
}
