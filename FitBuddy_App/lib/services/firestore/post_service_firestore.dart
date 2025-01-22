import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/models/FitBuddyActivityModel.dart';

import '../../models/FitBuddyExerciseModel.dart';
import '../auth.dart';
import 'firestore_service.dart';

class PostServiceFirestore {
  final FirestoreService firestoreService;

  PostServiceFirestore({required this.firestoreService});

  Stream<List<Exercise>> getFavoriteExercises() {
    DocumentReference docRef = firestoreService.instance
        .collection('users')
        .doc(Auth().currentUser?.uid);

    return docRef.snapshots().asyncMap((snapshot) async {
      List<Exercise> exercises = [];

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('favoriteExercises')) {
          List<dynamic>? favoriteExercises = data['favoriteExercises'];

          if (favoriteExercises != null) {
            List<Future<DocumentSnapshot>> fetchFutures = favoriteExercises
                .map((dynamic reference) =>
                    (reference as DocumentReference).get())
                .toList();
            List<DocumentSnapshot> documents = await Future.wait(fetchFutures);

            // Convert the DocumentSnapshots to Exercise objects
            exercises = documents
                .map((doc) => Exercise.fromMap(
                    doc.data() as Map<String, dynamic>, doc.id, true))
                .toList();
          } else {
            print("favoriteExercises is null");
          }
        } else {
          print("favoriteExercises not found");
        }
      } else {
        print("Document doesn't exist");
      }

      return exercises;
    });
  }

  Future<List<Exercise>> getAllExercises() async {
    QuerySnapshot querySnapshot =
        await firestoreService.instance.collection('exercises').get();

    List<Exercise> exercises = querySnapshot.docs
        .map((doc) =>
            Exercise.fromMap(doc.data() as Map<String, dynamic>, doc.id, false))
        .toList();

    return exercises;
  }

  void publishPost(List<Activity> activity, description, visibility) {
    firestoreService.instance.collection('posts').add({
      'activities': activity.map((e) => e.toMap()).toList(),
      'timestamp': FieldValue.serverTimestamp(),
      'creator_uid': Auth().currentUser?.uid,
      'description': description,
      'visibility': visibility,
    });
  }
}
