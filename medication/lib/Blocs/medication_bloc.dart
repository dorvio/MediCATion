import '../Database_classes/Medication.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class MedicationEvent {}

class LoadMedications extends MedicationEvent {
  final bool isAnimal;

  LoadMedications(this.isAnimal);
}

class AddMedication extends MedicationEvent {
  final Medication medication;

  AddMedication(this.medication);
}

class UpdateMedication extends MedicationEvent {
  final Medication medication;

  UpdateMedication(this.medication);
}

class DeleteMedication extends MedicationEvent {
  final String medicationId;

  DeleteMedication(this.medicationId);
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
    on<LoadMedications>((event, emit) async {
      try {
        emit(MedicationLoading());
        final medications = await _firestoreService.getMedications(event.isAnimal).first;
        emit(MedicationLoaded(medications));
      } catch (e) {
        emit(MedicationError('Failed to load medications.'));
      }
    });

    on<AddMedication>((event, emit) async {
      try {
        emit(MedicationLoading());
        await _firestoreService.addMedication(event.medication);
        emit(MedicationOperationSuccess('Medications added successfully.'));
      } catch (e) {
        emit(MedicationError('Failed to add medication.'));
      }
    });

    on<UpdateMedication>((event, emit)  async {
      try {
        emit(MedicationLoading());
        await _firestoreService.updateMedication(event.medication);
        emit(MedicationOperationSuccess('Medication updated successfully.'));
      } catch (e) {
        emit(MedicationError('Failed to update medications.'));
      }
    });

    on<DeleteMedication>((event, emit) async {
      try {
        emit(MedicationLoading());
        await _firestoreService.deleteMedication(event.medicationId);
        emit(MedicationOperationSuccess('Medication deleted successfully.'));
      } catch (e) {
        emit(MedicationError('Failed to delete medications.'));
      }
    });

  }
}