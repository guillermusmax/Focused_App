import 'package:flutter/material.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/views/models/log_item_widget.dart';
import 'package:focused_app/views/models/widget_side_bar.dart';
import 'package:focused_app/generated/l10n.dart'; // Importar para traducciones
import 'package:provider/provider.dart';
import '../../../api/state_models.dart';
import '../../models/widget_bottom_navbar.dart';

class MedicationView extends StatefulWidget {
  const MedicationView({super.key});

  @override
  State<MedicationView> createState() => _MedicationViewState();
}

class _MedicationViewState extends State<MedicationView> {

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<MedicationState>(context, listen: false).fetchMedications());
  }


  @override
  Widget build(BuildContext context) {
    final List<String> days =
    S.current.daysOfWeek.split(','); // Días de la semana traducidos
    int today = DateTime.now().weekday;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(S.current.medication), // Título traducible
      ),
      drawer: const WidgetSideBar(),
      bottomNavigationBar: const WidgetBottomNavBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(days.length, (index) {
              return CircleAvatar(
                radius: 20,
                backgroundColor:
                (index + 1) == today ? Colors.orange : primaryColor,
                child: Text(
                  days[index],
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 20),
              Text(
                S.current.logs, // Texto traducible
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 30,
                  color: Color(0xFF00695C),
                ),
              ),
            ],
          ),
          Expanded(
            child: Consumer<MedicationState>(
              builder: (context, state, _) {
                if (state.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.logs.isEmpty) {
                  return Center(
                    child: Text(
                      S.current.noMedicationsFound, // Mensaje traducible
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: state.logs.length,
                  itemBuilder: (context, index) {
                    final log = state.logs[index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LogItemWidget(
                        time: log['time'],
                        medications: (log['medications'] as List<Map<String, dynamic>>).map((med) {
                          return {
                            ...med,
                            'onToggleComplete': (bool? value) {
                              Provider.of<MedicationState>(context, listen: false)
                                  .toggleMedication(med['medlog_id'], med['taken']);
                            },
                          };
                        }).toList(),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
