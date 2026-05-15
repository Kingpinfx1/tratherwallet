<?php
include '../connection.php';

$user_id = $_POST['user_id'];

$stmt = $connectNow->prepare("SELECT * FROM users_table WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    $userDetails = $result->fetch_assoc();
    echo json_encode(array("success" => true, "userData" => $userDetails));
} else {
    echo json_encode(array("success" => false));
}

$stmt->close();
