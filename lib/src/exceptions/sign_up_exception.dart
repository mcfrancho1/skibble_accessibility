class SignUpWithEmailException {
  final String message;

  const SignUpWithEmailException([this.message = "An unknown error occurred"]);

  factory SignUpWithEmailException.code(String code) {
    switch(code) {
      case 'weak-password':
        return const SignUpWithEmailException('Please enter a strong password');
      case 'invalid-email':
        return const SignUpWithEmailException('Email is not valid');
      case 'email-already-in-use':
        return const SignUpWithEmailException('An account with this email already exists');
      case 'operation-not-allowed':
        return const SignUpWithEmailException('Operation not allowed. Please contact support');
      case 'user-disabled':
        return const SignUpWithEmailException('Your account was disabled. Please, contact support');

      default:
        return const SignUpWithEmailException();

    }
  }
}