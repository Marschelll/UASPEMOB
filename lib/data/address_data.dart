class Address {
  String title;
  String detail;

  Address({
    required this.title,
    required this.detail,
  });
}

List<Address> addressList = [
  Address(
    title: "Rumah",
    detail: "Jl. Merdeka No. 12, Bandung",
  ),
  Address(
    title: "Kos",
    detail: "Jl. Dipatiukur No. 45, Bandung",
  ),
];
