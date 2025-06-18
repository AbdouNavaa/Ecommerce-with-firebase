// ignore_for_file: public_member_api_docs, sort_constructors_first

class OrderChangeStatusReq {
  final String id;
  final String status;

  OrderChangeStatusReq({required this.id, required this.status});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'id': id, 'status': status};
  }
}
