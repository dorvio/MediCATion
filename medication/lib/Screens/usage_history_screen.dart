import 'package:flutter/material.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:medication/Blocs/usage_history_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Database_classes/UsageHistory.dart';
import 'package:table_calendar/table_calendar.dart';

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
  final AuthorizationService _authorizationService = AuthorizationService();
  List<UsageHistory> thisUsageHistory = [];

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
            return FutureBuilder(
              future: Future.delayed(Duration(milliseconds: 100)),
              builder: (context, snapshot) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      TableCalendar(
                        selectedDayPredicate: (day) {
                          for (DateTime d in usageDates) {
                            if (day.day == d.day &&
                                day.month == d.month &&
                                day.year == d.year) {
                              return true;
                            }
                          }
                          return false;
                        },
                        locale: 'pl_PL',
                        focusedDay: DateTime.now(),
                        firstDay: DateTime(2023, 10, 01),
                        lastDay: DateTime(2050, 3, 14),
                        startingDayOfWeek: StartingDayOfWeek.monday,
                        calendarStyle: CalendarStyle(
                          isTodayHighlighted: false,
                          weekendTextStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                          outsideTextStyle: TextStyle(
                            color: Colors.grey[600],
                          ),
                          defaultTextStyle: TextStyle(
                            color: Colors.white,
                          ),
                          selectedDecoration: BoxDecoration(
                            color: Color.fromARGB(255, 175, 77, 152),
                            shape: BoxShape.circle,
                          ),
                        ),
                        headerStyle: HeaderStyle(
                          titleTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 15
                          ),
                          formatButtonVisible: false,
                          rightChevronIcon: Icon(
                              Icons.chevron_right,
                              color: Colors.white
                          ),
                          leftChevronIcon: Icon(
                              Icons.chevron_left,
                              color: Colors.white
                          ),
                        ),
                        daysOfWeekStyle: DaysOfWeekStyle(
                          weekdayStyle: TextStyle(
                            color: Colors.white,
                          ),
                          weekendStyle: TextStyle(
                            color: Colors.grey[400],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
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
