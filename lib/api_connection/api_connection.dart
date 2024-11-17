class API {
  static const hostConnect = "https://alapi.alcoinbox.online/";
  // static const hostConnect = "http://172.20.10.5/first_wallet";

  static const hostConnectUser = "$hostConnect/user";

  static const hostConnectAdmin = "$hostConnect/admin";

  //user
  static const validateEmail = "$hostConnectUser/validate_email.php";

  static const signUp = "$hostConnectUser/signup.php";

  static const login = "$hostConnectUser/login.php";

  static const readUserDetails = "$hostConnectUser/readuserdetails.php";

  // admin
  static const adminLogin = "$hostConnectAdmin/login.php";

  static const readAllUsers = "$hostConnectAdmin/read_users.php";

  static const updateUser = "$hostConnectAdmin/updateuser.php";

  static const updateWallet = "$hostConnectAdmin/updatewallet.php";

  static const deleteUser = "$hostConnectAdmin/deleteuser.php";

  static const deletePaymentMethod = "$hostConnectAdmin/deletepayment.php";

  static const adminUploadWallet = "$hostConnectAdmin/adminuploadwallet.php";

  static const readAllWallets = "$hostConnectAdmin/readallwallets.php";
}
