class UserData {
  String? name;
  String? email;
  String? role;

  UserData({required this.name,required this.email,required this.role});

  UserData.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    email = json['email']??"";
    role = json['role']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['role'] = this.role;
    return data;
  }
}