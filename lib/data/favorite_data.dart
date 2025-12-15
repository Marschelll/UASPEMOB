class ParkingModel {
  final String name;
  final String location;
  final String price;
  bool isFavorite;

  ParkingModel({
    required this.name,
    required this.location,
    required this.price,
    this.isFavorite = false,
  });
}

List<ParkingModel> parkingList = [
  ParkingModel(
    name: "Plaza Medan Fair",
    location: "Jl. Gatot Subroto",
    price: "Rp5.000 / jam",
  ),
  ParkingModel(
    name: "Sun Plaza",
    location: "Jl. KH Zainul Arifin",
    price: "Rp7.000 / jam",
  ),
  ParkingModel(
    name: "Alfamart Padang Bulan",
    location: "Jl. Jamin Ginting",
    price: "Rp3.000 / jam",
  ),
];
