class OurOrder {
  final String documentId;
  final int totallPrice;
  final String address;

  OurOrder({
    required this.documentId,
    required this.totallPrice,
    required this.address,
  });
  // from json
  OurOrder.fromJson(Map<String, dynamic> json)
    : documentId = json['documentId'],
      totallPrice = json['totallPrice'],
      address = json['address'];
  // to json
  Map<String, dynamic> toJson() {
    return {
      'documentId': documentId,
      'totallPrice': totallPrice,
      'address': address,
    };
  }
}
