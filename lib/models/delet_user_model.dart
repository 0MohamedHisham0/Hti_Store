class DeleteUserModel {
  bool? status;
  String? message;

  DeleteUserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
  }
}
