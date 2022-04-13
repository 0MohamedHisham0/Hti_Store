class LoginModel {
  bool? status;
  String? message;
  UserData? data;

  LoginModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = (json['data'] != null ? UserData.fromJson(json['data']) : null)!;
  }
}

 class UserData {
  int? id;
  String? username;
  String? email;
  String? roles;
  String? sections;
  String? branch;

  // named constructor
  UserData() {
    id = id;
    username = username;
    email = email;
    roles = email;
    sections = email;
    branch = email;
  }
  // named constructor
  UserData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    email = json['email'];
    roles = json['roles'];
    sections = json['sections'];
    branch = json['branch'];
  }


}
