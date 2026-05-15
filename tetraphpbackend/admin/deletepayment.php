<?php
include '../connection.php';
require 'auth.php';

$id = $_POST['id'];

$stmt = $connectNow->prepare("DELETE FROM payment_methods WHERE id = ?");
$stmt->bind_param("i", $id);
$result = $stmt->execute();

echo json_encode(array("success" => (bool)$result));
$stmt->close();
