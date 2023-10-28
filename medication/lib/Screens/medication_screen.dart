import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Blocks/usage_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicationView extends StatefulWidget {
  final String profileId;
  final String profileName;

  const MedicationView({
    Key? key,
    required this.profileId,
    required this.profileName,
  }) : super(key: key);

  @override
  State<MedicationView> createState() => _MedicationViewState();
  }

class _MedicationViewState extends State<MedicationView> {

  @override
  void initState() {
    BlocProvider.of<UsageBloc>(context).add(LoadUsages());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('MediCATion'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.grey[900],
      body: BlocBuilder<UsageBloc, UsageState>(
        builder: (context, state) {
          if (state is UsageInitial) {
            return CircularProgressIndicator();
          } else if (state is UsageLoading) {
            return CircularProgressIndicator();
          } else if (state is UsageLoaded) {
            final usages = state.usages;
            return Column(
              children: [
                const SizedBox(height: 10),
                Container(
                  height: 40,
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      widget.profileName,
                      style: GoogleFonts.tiltNeon(
                        textStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Divider(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  height: 3,
                ),
              ],
            );
          } else if (state is UsageError) {
            return Center(
              child: Text(
                state.errorMessage,
                style: TextStyle(
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
