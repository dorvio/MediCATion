import '../Database_classes/Type.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class TypeEvent {}

class LoadTypes extends TypeEvent {}

class AddType extends TypeEvent {
  final Type type;

  AddType(this.type);
}

class UpdateType extends TypeEvent {
  final Type type;

  UpdateType(this.type);
}

class DeleteType extends TypeEvent {
  final String typeId;

  DeleteType(this.typeId);
}

@immutable
abstract class TypeState {}

class TypeInitial extends TypeState {}

class TypeLoading extends TypeState {}

class TypeLoaded extends TypeState {
  final List<Type> types;

  TypeLoaded(this.types);
}

class TypeOperationSuccess extends TypeState {
  final String message;

  TypeOperationSuccess(this.message);
}

class TypeError extends TypeState {
  final String errorMessage;

  TypeError(this.errorMessage);
}

class TypeBloc extends Bloc<TypeEvent, TypeState> {
  final FirestoreService _firestoreService;

  TypeBloc(this._firestoreService) : super(TypeInitial()) {
    on<LoadTypes>((event, emit) async {
      try {
        emit(TypeLoading());
        final types = await _firestoreService.getTypes().first;
        emit(TypeLoaded(types));
      } catch (e) {
        emit(TypeError('Failed to load types.'));
      }
    });
  }
}