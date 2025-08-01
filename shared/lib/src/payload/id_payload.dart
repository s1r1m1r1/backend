class IdPayload {
  final int id;

  IdPayload(this.id);

  Map<String, dynamic> toJson() {
    return {'id': id};
  }

  factory IdPayload.fromJson(Map<String, dynamic> json) {
    return IdPayload(json['id'] as int);
  }
}
