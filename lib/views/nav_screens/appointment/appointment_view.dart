import 'package:flutter/material.dart';
import 'package:focused_app/api/api_service.dart';
import 'package:focused_app/api/models/auth_storage.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:focused_app/generated/l10n.dart'; // Importa las traducciones
import '../../models/appointment_card.dart';
import '../../models/filter_buttons.dart';
import '../../models/widget_bottom_navbar.dart';
import 'package:intl/intl.dart';

class AppointmentView extends StatefulWidget {
  const AppointmentView({super.key});

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
  final ApiService _apiService = ApiService();
  final AuthStorage _authStorage = AuthStorage();
  List<dynamic> _appointments = [];
  List<dynamic> _filteredAppointments = [];
  bool _isLoading = true;
  String _selectedFilter = 'Pending'; // Filtro por defecto

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    try {
      final String? token = await _authStorage.getToken();
      if (token != null && !JwtDecoder.isExpired(token)) {
        final appointments = await _apiService.getAppointments(token);
        //('Todas las citas obtenidas: $appointments'); // // para ver todas las citas obtenidas

        if (appointments != null) {
          setState(() {
            _appointments = appointments;
            //('Citas antes de aplicar el filtro: $_appointments'); // // antes de aplicar el filtro
            _applyFilter(_selectedFilter); // Aplicar el filtro al cargar
            //('Citas filtradas ($_selectedFilter): $_filteredAppointments'); // // después de aplicar el filtro
          });
        } else {
          //(S.current.errorLoadingAppointments); // Mensaje traducido
        }
      } else {
        //(S.current.invalidToken); // Mensaje traducido
      }
    } catch (e) {
      //("${S.current.errorFetchingAppointments}: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }


  void _handleFilterSelection(String filter) {
    setState(() {
      _selectedFilter = filter;
      _applyFilter(filter); // Aplicar el filtro seleccionado
    });
  }

  void _applyFilter(String filter) {
    final DateTime now = DateTime.now();

    if (filter == S.current.pendingFilter) {
      // Mostrar solo las citas pendientes (futuras)
      _filteredAppointments = _appointments.where((appointment) {
        final DateTime appointmentDate =
            DateTime.parse(appointment['appointment_date']);
        final TimeOfDay startTime = TimeOfDay(
          hour: int.parse(appointment['start_time'].split(':')[0]),
          minute: int.parse(appointment['start_time'].split(':')[1]),
        );
        final DateTime fullStartDate = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          startTime.hour,
          startTime.minute,
        );
        return fullStartDate.isAfter(now);
      }).toList();
    } else if (filter == S.current.completedFilter) {
      // Mostrar solo las citas completadas (pasadas)
      _filteredAppointments = _appointments.where((appointment) {
        final DateTime appointmentDate =
            DateTime.parse(appointment['appointment_date']);
        final TimeOfDay endTime = TimeOfDay(
          hour: int.parse(appointment['end_time'].split(':')[0]),
          minute: int.parse(appointment['end_time'].split(':')[1]),
        );
        final DateTime fullEndDate = DateTime(
          appointmentDate.year,
          appointmentDate.month,
          appointmentDate.day,
          endTime.hour,
          endTime.minute,
        );
        return fullEndDate.isBefore(now);
      }).toList();
    } else {
      // Mostrar todas las citas si no hay filtro
      _filteredAppointments = List.from(_appointments);
    }
  }

  String formatDate(String date) {
    final DateTime parsedDate = DateTime.parse(date);
    return DateFormat('dd MMM yyyy').format(parsedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(S.current.appointments,
          style: const TextStyle(color: textTertiaryColor),
        ), // Título traducido
      ),
      drawer: const WidgetSideBar(),
      bottomNavigationBar: const WidgetBottomNavBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                S.current.filterBy, // Texto traducido
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Center(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FilterButtons(onFilterSelected: _handleFilterSelection),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: Container(
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredAppointments.isEmpty
                      ? Center(
                          child: Text(
                            S.current.noAppointments, // Texto traducido
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        )
                      : ListView.builder(
                          itemCount: _filteredAppointments.length,
                          itemBuilder: (context, index) {
                            final appointment = _filteredAppointments[index];
                            final specialistType =
                                appointment['id_professional'] == 31
                                    ? S.current.psychologist // Texto traducido
                                    : appointment['id_professional'] == 36
                                        ? S.current
                                            .psychiatrist // Texto traducido
                                        : S.current.other; // Texto traducido
                            return AppointmentCard(
                              specialistType: specialistType,
                              doctorName:
                                  '${S.current.doctor} ${appointment['professional_name']} ${appointment['professional_lastname']}',
                              dateTime:
                                  '${formatDate(appointment['appointment_date'])} ${S.current.from} ${appointment['start_time']} ${S.current.to} ${appointment['end_time']}',
                            );
                          },
                        ),
            ),
          ),
        ],
      ),
    );
  }
}
