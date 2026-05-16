class API {
  //static const hostConnect = "https://api.tratherwallet.top/";
  static const hostConnect = "http://172.20.10.5/tetraphpbackend";

  static const hostConnectUser = "$hostConnect/user";

  static const hostConnectAdmin = "$hostConnect/admin";

  //user
  static const validateEmail = "$hostConnectUser/validate_email.php";

  static const signUp = "$hostConnectUser/signup.php";

  static const login = "$hostConnectUser/login.php";

  static const readUserDetails = "$hostConnectUser/readuserdetails.php";

  static const deleteAccount = "$hostConnectUser/deleteaccount.php";

  static const withdrawalRequest = "$hostConnectUser/withdrawal_request.php";

  static const checkWithdrawals = "$hostConnectUser/check_withdrawals.php";

  static const getUserWallets = "$hostConnectUser/generate_user_wallets.php";

  // admin
  static const adminLogin = "$hostConnectAdmin/login.php";

  static const readAllUsers = "$hostConnectAdmin/read_users.php";

  static const updateUser = "$hostConnectAdmin/updateuser.php";

  static const updateWallet = "$hostConnectAdmin/updatewallet.php";

  static const deleteUser = "$hostConnectAdmin/deleteuser.php";

  static const deletePaymentMethod = "$hostConnectAdmin/deletepayment.php";

  static const adminUploadWallet = "$hostConnectAdmin/adminuploadwallet.php";

  static const readAllWallets = "$hostConnectAdmin/readallwallets.php";

  static const readWithdrawals = "$hostConnectAdmin/read_withdrawals.php";

  static const updateWithdrawal = "$hostConnectAdmin/update_withdrawal.php";
}
