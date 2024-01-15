import 'package:cloud_firestore/cloud_firestore.dart';

class Review {
  final String? id;
  final String name;
  final int note;
  final String review;

 const Review({this.id, required this.name, required this.note, required this.review, });

  factory Review.fromSnapshot(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    // Use data() to retrieve the document data
    final data = snapshot.data()!;
    return Review(
      id : snapshot.id,
      name: data["name"],
      note: data["note"],
      review: data["review"],

    );
  }

  Map<String, dynamic> toDocument() => {
        "name": name,
        "review": review,
        "note": note,
      };

   toJson(){
    return {
      "name": name,
        "review": review,
        "note": note,
    };
   }   
 static Stream<List<Review>> getReviews() {
    final reviewCollection = FirebaseFirestore.instance.collection("Reviews");
    return reviewCollection.snapshots().map((querySnapshot) =>
        querySnapshot.docs.map((doc) => Review.fromSnapshot(doc)).toList());
  }
  
}
