import '../Database_classes/NotificationData.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

@immutable
abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  final String userId;

  LoadNotifications(this.userId);
}

class AddNotification extends NotificationEvent {
  final NotificationData notification;

  AddNotification(this.notification);
}

class DeleteNotification extends NotificationEvent {
  final int locNotId;

  DeleteNotification(this.locNotId);
}

@immutable
abstract class NotificationState {}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationData> notifications;

  NotificationLoaded(this.notifications);
}

class NotificationOperationSuccess extends NotificationState {
  final String message;

  NotificationOperationSuccess(this.message);
}

class NotificationError extends NotificationState {
  final String errorMessage;

  NotificationError(this.errorMessage);
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FirestoreService _firestoreService;

  NotificationBloc(this._firestoreService) : super(NotificationInitial()) {
    on<LoadNotifications>((event, emit) async {
      try {
        emit(NotificationLoading());
        final notifications = await _firestoreService.getNotifications(event.userId).first;
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError('Failed to load notifications.'));
      }
    });

    on<AddNotification>((event, emit) async {
      try {
        emit(NotificationLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(NotificationOperationSuccess('Notification added successfully.'));
        await _firestoreService.addNotification(event.notification);
        emit(NotificationOperationSuccess('Notification added successfully.'));
      } catch (e) {
        emit(NotificationError('Failed to add notification.'));
      }
    });

    on<DeleteNotification>((event, emit) async {
      try {
        emit(NotificationLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(NotificationOperationSuccess('Notification added successfully.'));
        await _firestoreService.deleteNotification(event.locNotId);
        emit(NotificationOperationSuccess('Notification deleted successfully.'));
      } catch (e) {
        emit(NotificationError('Failed to delete notification.'));
      }
    });

  }
}