class UserModel {
  String? email;
  String? firstname;
  String? lastname;
  String? role;
  String? id;

  UserModel({this.id, this.email, this.lastname, this.firstname, this.role}) {
    //transferRawMarkersToMarkers(markersRaw, markers);
  }
  Map<String, dynamic> toJson() => {
        "email": email,
        "firstname": firstname,
        "lastname": lastname,
        "role": role
      };

  static UserModel fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'],
        email: json['email'],
        firstname: json['firstname'],
        lastname: json['lastname'],
        role: json['role']);
  }
}
