class ParkingModel {
  final String id;
  final String name;
  final String location;
  final String price;
  bool isFavorite;

  ParkingModel({
    required this.id,
    required this.name,
    required this.location,
    required this.price,
    this.isFavorite = false,
  });

  factory ParkingModel.fromFirestore(String id, Map<String, dynamic> data) {
    return ParkingModel(
      id: id,
      name: data['name'],
      location: data['location'],
      price: data['price'],
      isFavorite: true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'location': location,
      'price': price,
      'createdAt': DateTime.now(),
    };
  }
}
