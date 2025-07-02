abstract class AbstractAuthLocalDataSource {
  /// Saves the user token to local storage.
  Future<void> saveUserToken(String token);

  /// Retrieves the user token from local storage.
  Future<String?> getUserToken();

  /// Logs out the user by deleting the token.
  Future<bool> logout();
}