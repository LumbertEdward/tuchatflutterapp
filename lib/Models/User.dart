class User{
  final String userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String email;
  final String password;

  User({required this.userId, required this.firstName, required this.lastName, required this.phone, required this.password, required this.email});

  factory User.fromMap(Map<String, dynamic> json) => User(
      userId: json['userId'],
      firstName: json['firstName'],
    lastName: json['lastName'],
    phone: json['phone'],
    password: json['password'],
    email: json['email']
  );

  Map<String, dynamic> toMap(){
    return {
      "userId": userId,
      "firstName": firstName,
      "lastName": lastName,
      "phone": phone,
      "password": password,
      "email": email
    };
  }

  @override
  String toString() {
    return 'User{userId: $userId, firstName: $firstName, lastName: $lastName, phone: $phone, email: $email, password: $password}';
  }
}