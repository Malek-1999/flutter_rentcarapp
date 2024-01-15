import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_rentcarapp/models/Review.dart';
//import 'package:flutter_rentcarapp/constants/data.dart';
class DatabaseHandler {

// Create Note
  static Future<void> createReview(Review review) async {
    final ReviewCollection = FirebaseFirestore.instance.collection("Reviews");
    final id = ReviewCollection.doc().id;
    final newReview = Review(
        id: id,
        name: review.name,
        note: review.note,
        review: review.review
    ).toDocument();

    try {
      ReviewCollection.doc(id).set(newReview);
    } catch (e) {
      print("Some error occur $e");
    }
  }


  // Read dealer
  static Stream<List<Review>>? getdealers() {
    final dealerCollection = FirebaseFirestore.instance.collection("Reviews");
    return dealerCollection.snapshots().map((querySnapshot) => querySnapshot.docs.map((e) => Review.fromSnapshot(e)).toList());
  }

/*
  // Update/Edit dealer
  static Future<void> updatedealer(Review review) async {
    final dealerCollection = FirebaseFirestore.instance.collection("Reviews");
    final newdealer = Review(
        id: review.id,
        name: review.name,
        note: review.note,
        review: review.review
    ).toDocument();

    try {
      await dealerCollection.doc(review.id).update(newdealer);
    } catch (e) {
      print("Some error occur $e");
    }
  }
*/

  //Delete Review
  static Future<void> deleteReview(String id) async {
    final ReviewCollection = FirebaseFirestore.instance.collection("Reviews");
    try {
      await ReviewCollection.doc(id).delete();
    } catch (e) {
      print("Some error occur $e");
    }
  }

}