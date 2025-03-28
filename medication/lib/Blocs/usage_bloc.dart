import '../Database_classes/Usage.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

///bloc class for usages
@immutable
abstract class UsageEvent {}

class LoadUsages extends UsageEvent {
  final String profileId;

  LoadUsages(this.profileId);
}

class AddUsage extends UsageEvent {
  final Usage usage;

  AddUsage(this.usage);
}

class UpdateUsage extends UsageEvent {
  final Usage usage;

  UpdateUsage(this.usage);
}

class DeleteUsage extends UsageEvent {
  final String usageId;

  DeleteUsage(this.usageId);
}

class LoadUsagesById extends UsageEvent {
  final String userId;

  LoadUsagesById(this.userId);
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

    ///on event LoadUsages
    on<LoadUsages>((event, emit) async {
      try {
        emit(UsageLoading());
        final usages = await _firestoreService.getUsages(event.profileId).first;
        emit(UsageLoaded(usages));
      } catch (e) {
        emit(UsageError('Failed to load usages.'));
      }
    });

    ///on event AddUsage
    on<AddUsage>((event, emit) async {
      try {
        emit(UsageLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(UsageOperationSuccess('Usage added successfully.'));
        await _firestoreService.addUsage(event.usage);
        emit(UsageOperationSuccess('Usage added successfully.'));
      } catch (e) {
        emit(UsageError('Failed to add usage.'));
      }
    });

    ///on event UpdateUsage
    on<UpdateUsage>((event, emit) async {
      try {
        emit(UsageLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(UsageOperationSuccess('Usage updated successfully.'));
        await _firestoreService.updateUsage(event.usage);
        emit(UsageOperationSuccess('Usage updated successfully.'));
      } catch (e) {
        emit(UsageError('Failed to update usage.'));
      }
    });

    ///on event DeleteUsage
    on<DeleteUsage>((event, emit) async {
      try {
        emit(UsageLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(UsageOperationSuccess('Usage deleted successfully.'));
        await _firestoreService.deleteUsage(event.usageId);
        emit(UsageOperationSuccess('Usage deleted successfully.'));
      } catch (e) {
        emit(UsageError('Failed to delete usage.'));
      }
    });

    ///on event LoadUsagesById
    on<LoadUsagesById>((event, emit) async {
      try {
        emit(UsageLoading());
        final usages = await _firestoreService.getUsagesById(event.userId).first;
        emit(UsageLoaded(usages));
      } catch (e) {
        emit(UsageError('Failed to load usages.'));
      }
    });
  }
}