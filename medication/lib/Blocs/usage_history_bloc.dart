import '../Database_classes/UsageHistory.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

@immutable
abstract class UsageHistoryEvent {}

class LoadUsageHistory extends UsageHistoryEvent {
  final String profileId;

  LoadUsageHistory(this.profileId);
}

class AddUsageHistory extends UsageHistoryEvent {
  final UsageHistory usageHistory;

  AddUsageHistory(this.usageHistory);
}

class DeleteUsageHistory extends UsageHistoryEvent {
  final String usageHistoryId;

  DeleteUsageHistory(this.usageHistoryId);
}

class LoadUsageHistoryById extends UsageHistoryEvent {
  final String userId;

  LoadUsageHistoryById(this.userId);
}

@immutable
abstract class UsageHistoryState {}

class UsageHistoryInitial extends UsageHistoryState {}

class UsageHistoryLoading extends UsageHistoryState {}

class UsageHistoryLoaded extends UsageHistoryState {
  final List<UsageHistory> history;

  UsageHistoryLoaded(this.history);
}

class UsageHistoryOperationSuccess extends UsageHistoryState {
  final String message;

  UsageHistoryOperationSuccess(this.message);
}

class UsageHistoryError extends UsageHistoryState {
  final String errorMessage;

  UsageHistoryError(this.errorMessage);
}

class UsageHistoryBloc extends Bloc<UsageHistoryEvent, UsageHistoryState> {
  final FirestoreService _firestoreService;

  UsageHistoryBloc(this._firestoreService) : super(UsageHistoryInitial()) {
    on<LoadUsageHistory>((event, emit) async {
      try {
        emit(UsageHistoryLoading());
        final history = await _firestoreService.getUsageHistory(event.profileId).first;
        emit(UsageHistoryLoaded(history));
      } catch (e) {
        emit(UsageHistoryError('Failed to load history.'));
      }
    });

    on<AddUsageHistory>((event, emit) async {
      try {
        emit(UsageHistoryLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(UsageHistoryOperationSuccess('History added successfully.'));
        await _firestoreService.addUsageHistory(event.usageHistory);
        emit(UsageHistoryOperationSuccess('History added successfully.'));
      } catch (e) {
        emit(UsageHistoryError('Failed to add history.'));
      }
    });

    on<DeleteUsageHistory>((event, emit) async {
      try {
        emit(UsageHistoryLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(UsageHistoryOperationSuccess('History added successfully.'));
        await _firestoreService.deleteUsageHistory(event.usageHistoryId);
        emit(UsageHistoryOperationSuccess('History deleted successfully.'));
      } catch (e) {
        emit(UsageHistoryError('Failed to delete history.'));
      }
    });

    on<LoadUsageHistoryById>((event, emit) async {
      try {
        emit(UsageHistoryLoading());
        final history = await _firestoreService.getUsageHistoryById(event.userId).first;
        emit(UsageHistoryLoaded(history));
      } catch (e) {
        emit(UsageHistoryError('Failed to load history.'));
      }
    });
  }
}