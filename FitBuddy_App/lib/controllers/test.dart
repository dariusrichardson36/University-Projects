import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core



Future<void> likeUser(String likerID, String likedID) async {
  try {
    var likerRef = FirebaseFirestore.instance.collection('users').doc(likerID);
    var likedRef = FirebaseFirestore.instance.collection('users').doc(likedID);

    var likerSnapshot = await likerRef.get();
    var likedSnapshot = await likedRef.get();

    if (likerSnapshot.exists && likedSnapshot.exists) {
      var likerData = likerSnapshot.data();
      var likedData = likedSnapshot.data();

      var likerAlreadyLiked =
          likerData?['Likes'] != null && likerData?['Likes'].contains(likedID);
      var likedAlreadyLiked =
          likedData?['Likes'] != null && likedData?['Likes'].contains(likerID);

      if (likerAlreadyLiked && likedAlreadyLiked) {
        var likerMatchData = {'userId': likedID};
        var likedMatchData = {'userId': likerID};

        await FirebaseFirestore.instance.runTransaction((transaction) async {
          var likerMatchesDoc = await transaction.get(likerRef);
          var likedMatchesDoc = await transaction.get(likedRef);

          var likerMatchesArray = (likerMatchesDoc.data()?['Matches'] as List<Map<String, dynamic>>?) ?? [];
          likerMatchesArray.add(likerMatchData);
          transaction.update(likerRef, {'Matches': likerMatchesArray});

          var likedMatchesArray = (likedMatchesDoc.data()?['Matches'] as List<Map<String, dynamic>>?) ?? [];
          likedMatchesArray.add(likedMatchData);
          transaction.update(likedRef, {'Matches': likedMatchesArray});

          print('Match found and updated in Firestore!');
        });
      } else {
        print('No mutual like yet.');
      }
    } else {
      print('One or both users not found.');
    }
  } catch (error) {
    print('Error: $error');
  }
}

void main() {
  likeUser('rqSGBB3172RJxfAbRSt67kskphz2', 'RECC73OmLuX4hqjADtQ4H5fDRCl2');
}
