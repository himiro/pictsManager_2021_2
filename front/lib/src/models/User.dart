class User {
  final int id;
  final String title;

  User({this.id, this.title});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      title: json['title'],
    );
  }
}