//Login exception
class UserNotFoundAuthException implements Exception {}

class WrongPasswordAuthException implements Exception {}

//Register exception
class WeakPasswordAuthException implements Exception {}

class EmailAlredyUseAuthException implements Exception {}

class InvaidEmailAuthException implements Exception {}

//Generic exception

class GenericAuthException implements Exception {}

class UserNotLoggedInAuthException implements Exception {}
