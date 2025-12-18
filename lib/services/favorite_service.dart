import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/parking_model.dart';

class FavoriteService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  User? get user => _auth.currentUser;

  CollectionReference get _favRef =>
      _firestore.collection('users').doc(user!.uid).collection('favorites');

  Future<void> addFavorite(ParkingModel parkir) async {
    await _favRef.doc(parkir.id).set(parkir.toFirestore());
  }

  Future<void> removeFavorite(String id) async {
    await _favRef.doc(id).delete();
  }

  Future<List<String>> getFavoriteIds() async {
    final snapshot = await _favRef.get();
    return snapshot.docs.map((e) => e.id).toList();
  }

  Stream<List<ParkingModel>> favoriteStream() {
    return _favRef.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ParkingModel.fromFirestore(
          doc.id,
          doc.data() as Map<String, dynamic>,
        );
      }).toList();
    });
  }
}
