<?php
include '../connection.php';

$userEmail = $_POST['user_email'];

$stmt = $connectNow->prepare("SELECT user_id FROM users_table WHERE user_email = ?");
$stmt->bind_param("s", $userEmail);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode(array("emailFound" => true));
} else {
    echo json_encode(array("emailFound" => false));
}

$stmt->close();
