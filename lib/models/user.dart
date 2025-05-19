class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  static List<User> getHardcodedUsers() {
    return [
      User(username: 'admin', password: '12345'),
      User(username: 'user', password: '12345'),
    ];
  }

  static bool authenticate(String username, String password) {
    final users = getHardcodedUsers();
    return users.any(
      (user) => user.username == username && user.password == password,
    );
  }
}
