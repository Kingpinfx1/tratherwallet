<?php
include '../connection.php';
require 'auth.php';

$user_id = $_POST['user_id'];

$stmt = $connectNow->prepare("DELETE FROM users_table WHERE user_id = ?");
$stmt->bind_param("i", $user_id);
$result = $stmt->execute();

echo json_encode(array("success" => (bool)$result));
$stmt->close();
