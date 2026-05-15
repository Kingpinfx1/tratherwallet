<?php
include '../connection.php';
require 'auth.php';

$user_balance = $_POST['user_balance'];
$user_id      = $_POST['user_id'];

$stmt = $connectNow->prepare("UPDATE users_table SET user_balance = ? WHERE user_id = ?");
$stmt->bind_param("si", $user_balance, $user_id);
$result = $stmt->execute();

echo json_encode(array("success" => (bool)$result));
$stmt->close();
