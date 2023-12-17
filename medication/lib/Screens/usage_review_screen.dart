import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:medication/Blocs/usage_history_bloc.dart';
import 'package:medication/Database_classes/Usage.dart';
import 'package:medication/Services/authorization.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medication/Database_classes/UsageHistory.dart';

class UsageReviewView extends StatefulWidget {
  final Usage usage;

  const UsageReviewView({
    Key? key,
    required this.usage,
  }) : super(key: key);

  @override
  State<UsageReviewView> createState() => _UsageReviewViewState();
}

class _UsageReviewViewState extends State<UsageReviewView> {
  final AuthorizationService _authorizationService = AuthorizationService();
  List<UsageHistory> history = [];
  List<UsageHistory> thisUsageHistory = [];
  int showInfo = 0;

  @override
  void initState() {
    BlocProvider.of<UsageHistoryBloc>(context).add(LoadUsageHistory(widget.usage.profileId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: SingleChildScrollView(
        child: BlocBuilder<UsageHistoryBloc, UsageHistoryState>(
          builder: (context, state) {
            if (state is UsageHistoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is UsageHistoryLoaded) {
              history = state.history;
              thisUsageHistory = history.where((element) => element.usageId == widget.usage.usageId).toList();
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
                    const SizedBox(height: 30),
                    const Text(
                      'DAWKA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.usage.doseData.join(' '),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 174, 199, 255),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'PODAWANIE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.usage.administration.join(', '),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 174, 199, 255),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'GODZINA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.usage.hour.join(', '),
                      style: const TextStyle(
                        color: Color.fromARGB(255, 174, 199, 255),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height:30),
                    const Text(
                      'POWIADOMIENIE',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.usage.notificationData[0] == 'Brak' ? 'Brak' : '${widget.usage.notificationData[0].toString().padLeft(2, '0')}:${widget.usage.notificationData[1].toString().padLeft(2, '0')}',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 174, 199, 255),
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'OGRANICZNIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.usage.restrictions,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 174, 199, 255),
                        fontSize: 20,
                      ),
                    ),
                    Visibility(
                      visible: widget.usage.probiotic != '',
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            'PROBIOTYK',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.usage.probiotic,
                            style: const TextStyle(
                              color: Color.fromARGB(255, 174, 199, 255),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'KONFLIKT Z INNYM LEKIEM',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.usage.conflict.length > 1 ? widget.usage.conflict.asMap()
                          .entries
                          .where((entry) => entry.key % 2 != 0)
                          .map((entry) => entry.value)
                          .join(', ')
                      : 'Brak',
                      style: const TextStyle(
                        color: Color.fromARGB(255, 174, 199, 255),
                        fontSize: 20,
                      ),
                    ),
                    Visibility(
                      visible: widget.usage.conflict.length > 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 30),
                          const Text(
                            'CZAS POMIĘDZY LEKAMI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            widget.usage.conflict.length > 1 ? widget.usage.conflict[0] : '',
                            style: const TextStyle(
                              color: Color.fromARGB(255, 174, 199, 255),
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 60),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.fromLTRB(40, 15, 40, 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          backgroundColor: const Color.fromARGB(255, 174, 199, 255),
                        ),
                        child: const Text(
                            'Podaj lek',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            )
                        ),
                        onPressed: () async {
                          bool result = await _checkUsage();
                          if(result == true) {
                            _addToUsageHistory();
                            setState(() {
                              showInfo = 1;
                            });
                            Timer timer = Timer(Duration(seconds: 3), () {
                              setState(() {
                                showInfo = 0;
                              });
                            });
                          } else {
                            setState(() {
                              showInfo = 2;
                            });
                            Timer timer = Timer(Duration(seconds: 3), () {
                              setState(() {
                                showInfo = 0;
                              });
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: Visibility(
                          visible: showInfo != 0,
                          child: Text(
                              showInfo == 1 ? "Lek został podany" : "Lek NIE został podany",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                              )
                          )
                      ),
                    )
                  ],
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
      ),
    );
  }

  Future<bool> _checkUsage() async {
    bool result = true;
    DateTime now = DateTime.now();
    if(widget.usage.hour[0] == 'Rano' || widget.usage.hour[0] == 'Wieczorem' || widget.usage.hour[0] == 'Po południu' || widget.usage.hour[0] == 'Na noc'){
      String administrationTimesOfDay = widget.usage.hour.map((h) => h.toLowerCase()).toList().join(', ');
      //kilka razy na dzień
      if(now.hour > 5 && now.hour < 12){
        if(widget.usage.hour.contains('Rano')){
          result = true;
        } else {
          result = await _showAlertDialog('Lek ${widget.usage.medicationName} ma być podawany $administrationTimesOfDay. Czy na pewno chcesz teraz podać lek?');
          if(!result) return false;
        }
      }
      else if (now.hour > 18 && now.hour < 22){
        if(widget.usage.hour.contains('Wieczorem')){
          result = true;
        } else {
          result = await _showAlertDialog('Lek ${widget.usage.medicationName} ma być podawany $administrationTimesOfDay. Czy na pewno chcesz teraz podać lek?');
          if(!result) return false;
        }
      }
      else if (now.hour > 12 && now.hour < 18){
        if(widget.usage.hour.contains('Po południu')){
          result = true;
        } else {
          result = await _showAlertDialog('Lek ${widget.usage.medicationName} ma być podawany $administrationTimesOfDay. Czy na pewno chcesz teraz podać lek?');
          if(!result) return false;
        }
      }
      else if (now.hour > 22 && now.hour < 5){
        if(widget.usage.hour.contains('Na noc')){
          result = true;
        } else {
          result = await _showAlertDialog('Lek ${widget.usage.medicationName} ma być podawany $administrationTimesOfDay. Czy na pewno chcesz teraz podać lek?');
          if(!result) return false;
        }
      }
    } else {
      //raz dziennie - sprawdzenie czy lek był już przyjęty tego dnia
      if (thisUsageHistory.isNotEmpty) {
        thisUsageHistory.sort((a, b) => b.date.compareTo(a.date));
        DateTime newestHistoryElement = DateTime.fromMillisecondsSinceEpoch(
            thisUsageHistory[0].date.millisecondsSinceEpoch);
        if (newestHistoryElement.year == now.year &&
            newestHistoryElement.month == now.month &&
            newestHistoryElement.day == now.day) {
          bool result = await _showAlertDialog(
              "Lek ${widget.usage.medicationName} został już dzisiaj podany o ${newestHistoryElement
                  .hour}:${newestHistoryElement
                  .minute}. Czy na pewno chcesz podać lek jeszcze raz?");
        }
      }
      //konkretna godzina
      if(widget.usage.hour[0] != 'Brak'){
          List<String> timeSplit = widget.usage.hour[0].split(":");
          int hour = int.parse(timeSplit[0]);
          int minute = int.parse(timeSplit[1]);
          if (
          hour == now.hour &&
              (minute >= now.minute - 5 && minute <= now.minute + 5)
          ){
            result = true;
          } else {
            bool result = await _showAlertDialog('Podanie leku ${widget.usage.medicationName} jest zaplanowane na ${widget.usage.hour[0]}. Czy na pewno chcesz podać ten lek teraz?');
            if(!result) return false;
          }
        }
      }
    if(widget.usage.administration[0] != 'Codziennie'){
      String dayName = getDayName(now.weekday);
      if(widget.usage.administration.contains(dayName)){
        result = true;
      } else {
        bool result = await _showAlertDialog('Dzisiaj jest ${dayName.toLowerCase()}. Na ten dzień nie ma zaplanowanego podania leku ${widget.usage.medicationName}. Czy na pewno chcesz podać ten lek?');
        if(!result) return false;
      }
    }
    if (widget.usage.conflict.length > 1) {
      List<String> conflictMedIds = widget.usage.conflict.asMap()
          .entries
          .where((entry) => entry.key % 2 == 0)
          .map((entry) => entry.value.toString())
          .toList();
      conflictMedIds.removeAt(0);
      List<String> conflictMeds = widget.usage.conflict.asMap()
          .entries
          .where((entry) => entry.key % 2 != 0)
          .map((entry) => entry.value.toString())
          .toList();
      String conflictMedId = widget.usage.conflict[2];
      List<String> parts = widget.usage.conflict[0].split(':');
      int hours = int.parse(parts[0]);
      int minutes = int.parse(parts[1]);
      Duration conflictTime = Duration(hours: hours, minutes: minutes);
      if (history.isNotEmpty) {
        List<UsageHistory> todayUsageHistory = history.where((element) {
          DateTime elementDate = DateTime.fromMillisecondsSinceEpoch(element.date.millisecondsSinceEpoch);
          DateTime today = DateTime(now.year, now.month, now.day);
          return elementDate.year == today.year &&
              elementDate.month == today.month &&
              elementDate.day == today.day;
        }).toList();
        for(int i = 0; i < conflictMedIds.length; i++) {
          if(todayUsageHistory.any((element) => element.usageId == conflictMedIds[i])){
            DateTime conflictUsageTime = DateTime.fromMillisecondsSinceEpoch(
                todayUsageHistory.firstWhere((element) => element.usageId == conflictMedId).date.millisecondsSinceEpoch);
            if(isBreakLonger(conflictUsageTime, now, conflictTime)){
              result = true;
            } else {
              result = await _showAlertDialog('Konfliktowy lek ${conflictMeds[i]} został przyjęty mniej niż ${conflictTime.inHours.toString().padLeft(2, '0')}:${conflictTime.inMinutes.remainder(60).toString().padLeft(2, '0')} temu. Podanie leku ${widget.usage.medicationName} może spowodować wystąpienie skutów ubocznych. Czy na pewno chcesz teraz podac ten lek?');
              if(!result) return false;
            }
          }
        }
      }
    }
    return result;
  }

  bool isBreakLonger(DateTime start, DateTime end, Duration breakDuration) {
    Duration timeDifference = end.difference(start);
    return timeDifference >= breakDuration;
  }

  String getDayName(int day){
    switch(day){
      case 1:
        return 'Poniedziałek';
      case 2:
        return 'Wtorek';
      case 3:
        return 'Środa';
      case 4:
        return 'Czwartek';
      case 5:
        return 'Piątek';
      case 6:
        return 'Sobota';
      case 7:
        return 'Niedziela';
    }
    return 'Brak';
  }

  Future<bool> _showAlertDialog(String data) async {
    Completer<bool> completer = Completer<bool>();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.grey[900],
              title: Text(
                'Uwaga!',
                style: const TextStyle(color: Colors.white),
              ),
              content: Text(
                data,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                ),
              ),
              actions: [
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('NIE'),
                  onPressed: () {
                    Navigator.pop(context);
                    completer.complete(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Theme.of(context).colorScheme.inversePrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                  child: const Text('TAK'),
                  onPressed: () {
                    Navigator.pop(context);
                    completer.complete(true); //
                  },
                ),
              ],
            );
          },
        );
      },
    );

    return completer.future;
  }

  void _addToUsageHistory(){
    final usageHistory = UsageHistory(
      usageHistoryId: DateTime.now().toString(),
      usageId: widget.usage.usageId,
      date: Timestamp.now(),
      profileId: widget.usage.profileId,
      userId: widget.usage.userId,
    );
    BlocProvider.of<UsageHistoryBloc>(context).add(AddUsageHistory(usageHistory));
  }

}
