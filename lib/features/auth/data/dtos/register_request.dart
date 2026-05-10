/// Request body for `POST /auth/register`.
///
/// Backend constraints (verified in `RegisterDto`):
/// * `password` — min 8 chars, must contain uppercase + digit + special.
/// * `phone` — international format, e.g. `+1234567890`.
class RegisterRequest {
  const RegisterRequest({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
    required this.phone,
  });

  final String email;
  final String password;
  final String firstName;
  final String lastName;
  final String phone;

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': password,
    'firstName': firstName,
    'lastName': lastName,
    'phone': phone,
  };
}
