import 'package:cloud_firestore/cloud_firestore.dart';
import '../Database_classes/Profile.dart';
import '../Database_classes/Medication.dart';
import '../Database_classes/Usage.dart';

class FirestoreService {
  final CollectionReference _profilesCollection =
  FirebaseFirestore.instance.collection('profiles');

  final CollectionReference _medicationsCollection =
  FirebaseFirestore.instance.collection('medications');

  final CollectionReference _usagesCollection =
  FirebaseFirestore.instance.collection('usages');

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


  Future<void> addProfile(Profile profile) {
    return _profilesCollection.add({
      'name': profile.name,
      'is_animal': profile.isAnimal,
      'user_id': profile.userId,
    });
  }

  Future<void> updateProfile(Profile profile) {
    return _profilesCollection.doc(profile.profileId.toString()).update({
      'name': profile.name,
    });
  }

  Future<void> deleteProfile(String profileId) {
    return _profilesCollection.doc(profileId).delete();
  }

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

  Future<void> addMedication(Medication medication) {
    return _medicationsCollection.add({
      'medication': medication.medication,
      'type': medication.type,
      'description': medication.description,
      'for_animal': medication.forAnimal,
    });
  }

  Future<void> updateMedication(Medication medication) {
    return _medicationsCollection.doc(medication.medicationId.toString()).update({
      'medication': medication.medication,
      'description': medication.description,
    });
  }

  Future<void> deleteMedication(String medicationId) {
    return _medicationsCollection.doc(medicationId).delete();
  }

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
        );
      }).toList();
    });
  }

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
    });
  }

  Future<void> updateUsage(Usage usage) {
    return _usagesCollection.doc(usage.usageId.toString()).update({
      'administration': usage.administration,
      'hour': usage.hour,
      'restrictions': usage.restrictions,
      'conflict': usage.conflict,
      'probiotic': usage.probiotic,
    });
  }

  Future<void> deleteUsage(String usageId) {
    return _usagesCollection.doc(usageId).delete();
  }

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
        );
      }).toList();
    });
  }
}