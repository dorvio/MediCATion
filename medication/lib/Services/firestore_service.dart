import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database_classes/Profile.dart';
import '../Database_classes/Medication.dart';
import '../Database_classes/Usage.dart';
import '../Database_classes/UsageHistory.dart';
import '../Database_classes/NotificationData.dart';

///class to handle all interactions with Firebase
class FirestoreService {

  ///references to collections in Firebase
  final CollectionReference _profilesCollection =
  FirebaseFirestore.instance.collection('profiles');

  final CollectionReference _medicationsCollection =
  FirebaseFirestore.instance.collection('medications');

  final CollectionReference _usagesCollection =
  FirebaseFirestore.instance.collection('usages');

  final CollectionReference _usageHistoryCollection =
  FirebaseFirestore.instance.collection('usage_history');

  final CollectionReference _notificationCollection =
  FirebaseFirestore.instance.collection('notifications');

  ///function to get profiles from Firebase for given user
  Stream<List<Profile>> getProfiles(String userId) {
    return _profilesCollection.where('user_id', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
         Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Profile(
          profileId: doc.id,
          name: data['name'],
          isAnimal: data['is_animal'],
          userId: data['user_id'],
        );
      }).toList();
    });
  }

  ///function to add new profile to Firebase
  Future<void> addProfile(Profile profile) {
    return _profilesCollection.add({
      'name': profile.name,
      'is_animal': profile.isAnimal,
      'user_id': profile.userId,
    });
  }

  ///function to update existing profile in Firebase
  Future<void> updateProfile(Profile profile) {
    return _profilesCollection.doc(profile.profileId.toString()).update({
      'name': profile.name,
    });
  }

  ///function to update existing profile in Firebase
  Future<void> deleteProfile(String profileId) {
    return _profilesCollection.doc(profileId).delete();
  }

  ///function to get medications from Firebase with given type
  Stream<List<Medication>> getMedications(bool isAnimal) {
    return _medicationsCollection.where('for_animal', isEqualTo: isAnimal).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Medication(
          medicationId: doc.id,
          medication: data['medication'],
          type: data['type'],
          description: data['description'],
          forAnimal: data['for_animal'],
        );
      }).toList();
    });
  }

  ///function to get all medications from Firebase
  Stream<List<Medication>> getAllMedications() {
    return _medicationsCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Medication(
          medicationId: doc.id,
          medication: data['medication'],
          type: data['type'],
          description: data['description'],
          forAnimal: data['for_animal'],
        );
      }).toList();
    });
  }

  ///function to add new medication to Firebase
  Future<void> addMedication(Medication medication) {
    return _medicationsCollection.add({
      'medication': medication.medication,
      'type': medication.type,
      'description': medication.description,
      'for_animal': medication.forAnimal,
    });
  }

  ///function to get usages from Firebase for given profile
  Stream<List<Usage>> getUsages(String profileId) {
    return _usagesCollection.where('profile_id', isEqualTo: profileId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Usage(
          usageId: doc.id,
          medicationName: data['medication_name'],
          profileId: data['profile_id'],
          administration: data['administration'],
          hour: data['hour'],
          restrictions: data['restrictions'],
          conflict: data['conflict'],
          probiotic: data['probiotic'],
          userId: data['user_id'],
          notificationData: data['notification_data'],
          doseData: data['dose_data'],
        );
      }).toList();
    });
  }

  ///function to add new usage to Firebase
  Future<void> addUsage(Usage usage) {
    return _usagesCollection.add({
      'medication_name': usage.medicationName,
      'profile_id': usage.profileId,
      'administration': usage.administration,
      'hour': usage.hour,
      'restrictions': usage.restrictions,
      'conflict': usage.conflict,
      'probiotic': usage.probiotic,
      'user_id': usage.userId,
      'notification_data' : usage.notificationData,
      'dose_data': usage.doseData,
    });
  }

  ///function to update existing usage in Firebase
  Future<void> updateUsage(Usage usage) {
    return _usagesCollection.doc(usage.usageId.toString()).update({
      'administration': usage.administration,
      'hour': usage.hour,
      'restrictions': usage.restrictions,
      'conflict': usage.conflict,
      'probiotic': usage.probiotic,
      'notification_data' : usage.notificationData,
      'dose_data': usage.doseData,
    });
  }

  ///function to delete existing usage from Firebase
  Future<void> deleteUsage(String usageId) {
    return _usagesCollection.doc(usageId).delete();
  }

  ///function to get usages from Firebase for given user
  Stream<List<Usage>> getUsagesById(String userId){
    return _usagesCollection.where('user_id', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return Usage(
          usageId: doc.id,
          medicationName: data['medication_name'],
          profileId: data['profile_id'],
          administration: data['administration'],
          hour: data['hour'],
          restrictions: data['restrictions'],
          conflict: data['conflict'],
          probiotic: data['probiotic'],
          userId: data['user_id'],
          notificationData: data['notification_data'],
          doseData: data['dose_data'],
        );
      }).toList();
    });
  }

  ///function to get usage history from Firebase for given profile
  Stream<List<UsageHistory>> getUsageHistory(String profileId) {
    return _usageHistoryCollection.where('profile_id', isEqualTo: profileId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UsageHistory(
          usageHistoryId: doc.id,
          usageId: data['usage_id'],
          date: data['date'],
          profileId: data['profile_id'],
          userId: data['user_id'],
        );
      }).toList();
    });
  }

  ///function to add new usage history to Firebase
  Future<void> addUsageHistory(UsageHistory usageHistory) {
    return _usageHistoryCollection.add({
      'usage_id': usageHistory.usageId,
      'date' : usageHistory.date,
      'profile_id': usageHistory.profileId,
      'user_id': usageHistory.userId,
    });
  }

  ///function to get usage history from Firebase for given user
  Stream<List<UsageHistory>> getUsageHistoryById(String userId){
    return _usageHistoryCollection.where('user_id', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return UsageHistory(
          usageHistoryId: doc.id,
          usageId: data['usage_id'],
          date: data['date'],
          profileId: data['profile_id'],
          userId: data['user_id'],
        );
      }).toList();
    });
  }

  ///function to get notification information from Firebase for given user
  Stream<List<NotificationData>> getNotifications(String userId) {
    return _notificationCollection.where('user_id', isEqualTo: userId).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return NotificationData(
          notificationId: doc.id,
          locNotId: data['loc_not_id'],
          userId: data['user_id'],
          body: data['body'],
          hour: data['hour'],
          minute: data['minute'],
          weekday: data['weekday'],
        );
      }).toList();
    });
  }

  ///function to add new notification information to Firebase
  Future<void> addNotification(NotificationData notification) {
    return _notificationCollection.add({
      'loc_not_id': notification.locNotId,
      'user_id': notification.userId,
      'body': notification.body,
      'hour': notification.hour,
      'minute': notification.minute,
      'weekday': notification.weekday,
    });
  }

  ///function to delete existing notification information from Firebase
  Future<void> deleteNotification(int awNotId) async {
    return _notificationCollection.where("loc_not_id", isEqualTo: awNotId).get().then((snapshot){
      snapshot.docs.first.reference.delete();
    });
  }
}