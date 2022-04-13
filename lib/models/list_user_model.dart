import 'login_model.dart';

class ListUsers {
  int? userCount;
  ListUserData? result;

  ListUsers.fromJson(Map<String, dynamic> json) {
    userCount = json['userCount'];
    result = json['result'] != null ? ListUserData.fromJson(json['result']) : null;
  }
}
class ListUserData {
  List<UserData>? data = [];

  ListUserData.fromJson(List<dynamic> json) {
    for (var element in json) {
      data!.add(UserData.fromJson(element));
    }
  }
}


