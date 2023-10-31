import '../Database_classes/Usage.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class UsageEvent {}

class LoadUsages extends UsageEvent {}

class AddUsage extends UsageEvent {
  final Usage usage;

  AddUsage(this.usage);
}

@immutable
abstract class UsageState {}

class UsageInitial extends UsageState {}

class UsageLoading extends UsageState {}

class UsageLoaded extends UsageState {
  final List<Usage> usages;

  UsageLoaded(this.usages);
}

class UsageOperationSuccess extends UsageState {
  final String message;

  UsageOperationSuccess(this.message);
}

class UsageError extends UsageState {
  final String errorMessage;

  UsageError(this.errorMessage);
}

class UsageBloc extends Bloc<UsageEvent, UsageState> {
  final FirestoreService _firestoreService;

  UsageBloc(this._firestoreService) : super(UsageInitial()) {
    on<LoadUsages>((event, emit) async {
      try {
        emit(UsageLoading());
        final usages = await _firestoreService.getUsages().first;
        emit(UsageLoaded(usages));
      } catch (e) {
        emit(UsageError('Failed to load usages.'));
      }
    });

    on<AddUsage>((event, emit) async {
      try {
        emit(UsageLoading());
        await _firestoreService.addUsage(event.usage);
        emit(UsageOperationSuccess('Usage added successfully.'));
      } catch (e) {
        emit(UsageError('Failed to add usages.'));
      }
    });

  }
}