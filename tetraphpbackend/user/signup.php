<?php
include '../connection.php';

$userFirstName = $_POST['user_firstname'];
$userLastName  = $_POST['user_lastname'];
$userAddress   = $_POST['user_address'];
$userEmail     = $_POST['user_email'];
$userPassword  = password_hash($_POST['user_password'], PASSWORD_BCRYPT);

// Server-side email uniqueness check (defence-in-depth beyond Flutter's validate_email call)
$check = $connectNow->prepare("SELECT user_id FROM users_table WHERE user_email = ?");
$check->bind_param("s", $userEmail);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    echo json_encode(array("success" => false, "message" => "Email already in use"));
    $check->close();
    exit;
}
$check->close();

$stmt = $connectNow->prepare(
    "INSERT INTO users_table (user_firstname, user_lastname, user_address, user_email, user_password)
     VALUES (?, ?, ?, ?, ?)"
);
$stmt->bind_param("sssss", $userFirstName, $userLastName, $userAddress, $userEmail, $userPassword);
$result = $stmt->execute();

echo json_encode(array("success" => (bool)$result));
$stmt->close();
