import 'package:flutter/material.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/usage_history_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Database_classes/UsageHistory.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

///class to display history of medication administration
class UsageHistoryView extends StatefulWidget {
  final Usage usage;

  const UsageHistoryView({
    Key? key,
    required this.usage,
  }) : super(key: key);

  @override
  State<UsageHistoryView> createState() => _UsageHistoryViewState();
}

class _UsageHistoryViewState extends State<UsageHistoryView> {
  List<UsageHistory> thisUsageHistory = [];
  Map<DateTime, int> heatMapData = {};

  @override
  void initState() {
    BlocProvider.of<UsageHistoryBloc>(context).add(LoadUsageHistory(widget.usage.usageId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: BlocBuilder<UsageHistoryBloc, UsageHistoryState>(
        builder: (context, state) {
          if (state is UsageHistoryLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UsageHistoryLoaded) {
            final history = state.history;
            thisUsageHistory = history.where((element) => element.usageId == widget.usage.usageId).toList();
            List<DateTime> usageDates = thisUsageHistory.map((element) => DateTime.fromMillisecondsSinceEpoch(element.date.millisecondsSinceEpoch)).toList();
            if(thisUsageHistory.isNotEmpty) {
              // usageDates = usageDates.map((date) {
              //   return DateTime(date.year, date.month, date.day);
              // }).toList();

              heatMapData = usageDates.fold({}, (map, dateTime) {
                DateTime cleanedDateTime = DateTime(dateTime.year, dateTime.month, dateTime.day);
                map[cleanedDateTime] = 1;
                return map;
              });
            }
            return Container(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          MdiIcons.pill,
                          color: const Color.fromARGB(255, 174, 199, 255),
                          size: 35,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.usage.medicationName,
                          style: GoogleFonts.tiltNeon(
                            textStyle: const TextStyle(
                              color: Color.fromARGB(255, 174, 199, 255),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                  ),
                  const SizedBox(height: 50),
                    HeatMapCalendar(
                      showColorTip: false,
                      textColor: Colors.white,
                      defaultColor: Colors.grey[700],
                      colorsets: {
                        1: Color.fromARGB(255, 175, 77, 152),
                      },
                      datasets: heatMapData,
                      weekTextColor: Colors.white,
                    ),
              ]
            ),
          );
          } else if (state is UsageHistoryOperationSuccess) {
            BlocProvider.of<UsageHistoryBloc>(context).add(LoadUsageHistory(widget.usage.profileId));
            return Container();
          } else if (state is UsageHistoryError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

}
