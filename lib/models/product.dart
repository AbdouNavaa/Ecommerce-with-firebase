class Product {
  String? pName;
  String? pPrice;
  String? pLocation;
  String? pDescription;
  String? pCategory;
  String? pId;
  int? pQuantity;
  Product({
    this.pQuantity,
    this.pId,
    this.pName,
    this.pCategory,
    this.pDescription,
    this.pLocation,
    this.pPrice,
  });
  // from json
  Product.fromJson(Map<String, dynamic> json) {
    pName = json['pName'];
    pPrice = json['pPrice'];
    pLocation = json['pLocation'];
    pDescription = json['pDescription'];
    pCategory = json['pCategory'];
    pId = json['pId'];
    pQuantity = json['pQuantity'];
  }
  // to json
  Map<String, dynamic> toJson() {
    return {
      'pName': pName,
      'pPrice': pPrice,
      'pLocation': pLocation,
      'pDescription': pDescription,
      'pCategory': pCategory,
      'pId': pId,
      'pQuantity': pQuantity,
    };
  }
}
