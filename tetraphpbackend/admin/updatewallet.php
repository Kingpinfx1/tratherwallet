<?php
include '../connection.php';
require 'auth.php';

$description = $_POST['description'];
$id          = $_POST['id'];

$stmt = $connectNow->prepare("UPDATE payment_methods SET description = ? WHERE id = ?");
$stmt->bind_param("si", $description, $id);
$result = $stmt->execute();

echo json_encode(array("success" => (bool)$result));
$stmt->close();
