import '../Database_classes/Medication.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


///bloc class for medications
@immutable
abstract class MedicationEvent {}

class LoadMedications extends MedicationEvent {
  final bool isAnimal;

  LoadMedications(this.isAnimal);
}

class LoadAllMedications extends MedicationEvent {

  LoadAllMedications();
}

class AddMedication extends MedicationEvent {
  final Medication medication;

  AddMedication(this.medication);
}

@immutable
abstract class MedicationState {}

class MedicationInitial extends MedicationState {}

class MedicationLoading extends MedicationState {}

class MedicationLoaded extends MedicationState {
  final List<Medication> medications;

  MedicationLoaded(this.medications);
}

class MedicationOperationSuccess extends MedicationState {
  final String message;

  MedicationOperationSuccess(this.message);
}

class MedicationError extends MedicationState {
  final String errorMessage;

  MedicationError(this.errorMessage);
}

class MedicationBloc extends Bloc<MedicationEvent, MedicationState> {
  final FirestoreService _firestoreService;

  MedicationBloc(this._firestoreService) : super(MedicationInitial()) {

    ///on event LoadMedications
    on<LoadMedications>((event, emit) async {
      try {
        emit(MedicationLoading());
        final medications = await _firestoreService.getMedications(event.isAnimal).first;
        emit(MedicationLoaded(medications));
      } catch (e) {
        emit(MedicationError('Failed to load medications.'));
      }
    });

    ///on event LoadAllMedications
    on<LoadAllMedications>((event, emit) async {
      try {
        emit(MedicationLoading());
        final medications = await _firestoreService.getAllMedications().first;
        emit(MedicationLoaded(medications));
      } catch (e) {
        emit(MedicationError('Failed to load medications.'));
      }
    });

    ///on event AddMedication
    on<AddMedication>((event, emit) async {
      try {
        emit(MedicationLoading());
        await _firestoreService.addMedication(event.medication);
        emit(MedicationOperationSuccess('Medications added successfully.'));
      } catch (e) {
        emit(MedicationError('Failed to add medication.'));
      }
    });

  }
}