import '../Database_classes/Profile.dart';
import 'package:flutter/foundation.dart';
import '../Services/firestore_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

///bloc class for profiles
@immutable
abstract class ProfileEvent {}

class LoadProfiles extends ProfileEvent {
  final String userId;

  LoadProfiles(this.userId);
}

class AddProfile extends ProfileEvent {
  final Profile profile;

  AddProfile(this.profile);
}

class UpdateProfile extends ProfileEvent {
  final Profile profile;

  UpdateProfile(this.profile);
}

class DeleteProfile extends ProfileEvent {
  final String profileId;

  DeleteProfile(this.profileId);
}

@immutable
abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final List<Profile> profiles;

  ProfileLoaded(this.profiles);
}

class ProfileOperationSuccess extends ProfileState {
  final String message;

  ProfileOperationSuccess(this.message);
}

class ProfileError extends ProfileState {
  final String errorMessage;

  ProfileError(this.errorMessage);
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final FirestoreService _firestoreService;

  ProfileBloc(this._firestoreService) : super(ProfileInitial()) {

    ///on event LoadProfiles
    on<LoadProfiles>((event, emit) async {
      try {
        emit(ProfileLoading());
        final profiles = await _firestoreService.getProfiles(event.userId).first;
        emit(ProfileLoaded(profiles));
      } catch (e) {
        emit(ProfileError('Failed to load profiles.'));
      }
    });

    ///on event AddProfile
    on<AddProfile>((event, emit) async {
      try {
        emit(ProfileLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(ProfileOperationSuccess('Profile added successfully.'));
        await _firestoreService.addProfile(event.profile);
        emit(ProfileOperationSuccess('Profile added successfully.'));
      } catch (e) {
        emit(ProfileError('Failed to add profile.'));
      }
    });

    ///on event UpdateProfile
    on<UpdateProfile>((event, emit)  async {
      try {
        emit(ProfileLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(ProfileOperationSuccess('Profile added successfully.'));
        await _firestoreService.updateProfile(event.profile);
        emit(ProfileOperationSuccess('Profile updated successfully.'));
      } catch (e) {
        emit(ProfileError('Failed to update profile.'));
      }
    });

    ///on event DeleteProfile
    on<DeleteProfile>((event, emit) async {
      try {
        emit(ProfileLoading());
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none)
          emit(ProfileOperationSuccess('Profile added successfully.'));
        await _firestoreService.deleteProfile(event.profileId);
        emit(ProfileOperationSuccess('Profile deleted successfully.'));
      } catch (e) {
        emit(ProfileError('Failed to delete profile.'));
      }
    });

  }
}